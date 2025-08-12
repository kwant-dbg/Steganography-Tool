function message = extractLSB(stego, varargin)
if ischar(stego) || isstring(stego)
    I = imread(stego);
else
    I = stego;
end
I = uint8(I);
vec = I(:);
capacity = numel(vec);
p = 1:capacity;
if nargin > 1
    for k = 1:2:numel(varargin)
        if strcmpi(varargin{k},'Key')
            key = varargin{k+1};
            keybytes = double(char(key));
            seed = mod(sum(keybytes .* (1:numel(keybytes))), 2^31-1);
            rng(seed, 'twister');
            p = randperm(capacity);
        end
    end
end
headerIdx = p(1:32);
headerBits = zeros(32,1);
for i = 1:32
    headerBits(i) = bitget(vec(headerIdx(i)),1);
end
headerBits = headerBits(:)';
msgLenBytes = typecast(uint8(bi2de(reshape(headerBits,8,4)','left-msb')),'uint32');
msgLen = double(msgLenBytes);
numMsgBits = msgLen * 8;
if 32 + numMsgBits > capacity
    error('Header indicates message longer than available capacity.');
end
msgIdx = p(33:32+numMsgBits);
msgBits = zeros(numMsgBits,1);
for i = 1:numMsgBits
    msgBits(i) = bitget(vec(msgIdx(i)),1);
end
msgBits = reshape(msgBits,8,[])';
bytes = uint8(bi2de(msgBits,'left-msb'));
message = char(bytes')';
end
