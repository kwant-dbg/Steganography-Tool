function stego = embedLSB(cover, message, varargin)
if ischar(cover) || isstring(cover)
    I = imread(cover);
else
    I = cover;
end
I = uint8(I);
coverVec = I(:);
capacity = numel(coverVec);
msgBytes = uint8(message(:));
msgLenBytes = uint32(numel(msgBytes));
headerBits = de2bi(typecast(msgLenBytes,'uint32'), 32, 'left-msb')';
msgBits = reshape(de2bi(msgBytes,8,'left-msb')',[],1);
bitstream = [headerBits; msgBits];
numBits = numel(bitstream);
if numBits > capacity
    error('Message too large for cover image. Capacity (bits) = %d, needed = %d', capacity, numBits);
end
p = 1:capacity;
if nargin > 2
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
selectedIdx = p(1:numBits);
for k = 1:numBits
    coverVec(selectedIdx(k)) = bitset(coverVec(selectedIdx(k)), 1, bitstream(k));
end
stego = reshape(coverVec, size(I));
stego = uint8(stego);
end
