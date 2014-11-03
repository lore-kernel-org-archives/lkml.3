Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaKCSWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:22:35 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaKCSWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:22:33 -0500
Message-ID: <5457C7E3.9000104@nod.at>
Date: Mon, 03 Nov 2014 19:22:27 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Ming Lei <tom.leiming@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>,
        dedekind1@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        computersforpeace@gmail.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <CACVXFVP9K6t-u-sjBQ57r_9kzu-yGdLLGYyX2d+ryJBSxMkAJQ@mail.gmail.com> <545789F8.1060401@free-electrons.com>
In-Reply-To: <545789F8.1060401@free-electrons.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qGAgqvhehk6hdkudpXXcWivT7L51nsl8i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qGAgqvhehk6hdkudpXXcWivT7L51nsl8i
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 03.11.2014 um 14:58 schrieb Ezequiel Garcia:
> On 11/03/2014 02:03 AM, Ming Lei wrote:
>> On Sun, Nov 2, 2014 at 9:00 PM, Richard Weinberger <richard@nod.at> wr=
ote:
>>> Convert the driver to blk-mq.
>>
>> It is always helpful to include some performance comparison data(
>> randrw, rw) between blk-mq and non-mq.
>>
>=20
> UBI block support is read-only for now so you'll be able to run read
> tests only.
>=20
> Richard: If at all possible, it would be interested to so some
> performance tests on *real* devices, not only RAM-based ones.

Sure. There you go:

nand: device found, Manufacturer ID: 0x2c, Chip ID: 0xda
nand: Micron NAND 256MiB 3,3V 8-bit
nand: 256MiB, SLC, page size: 2048, OOB size: 64

root@debian-armhf:~# dd if=3D/dev/ubiblock0_0 of=3D/dev/zero bs=3D1M
243+1 records in
243+1 records out
255080448 bytes (255 MB) copied, 4.39295 s, 58.1 MB/s

vs.

root@debian-armhf:~# dd if=3D/dev/ubiblock0_0 of=3D/dev/zero bs=3D1M
243+1 records in
243+1 records out
255080448 bytes (255 MB) copied, 2.87676 s, 88.7 MB/s

Thanks,
//richard


--qGAgqvhehk6hdkudpXXcWivT7L51nsl8i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUV8fjAAoJEPmeIjfg4UaasggQAIpShvGmW0Pggfcy3T7Y/1aX
jBaJLvzsvGdNObiXzpUoi88FMqUVWW819OIVU2OkJwzevgC852aN3ac6C9DnklBI
+hOFI9jRjtxlnb6s8VZr/kqIUH63U8G4Zu7CzVJSUhVNHYfsfwckrr0gzz7Z4rNw
QOJcP2gZiVfJQnfXsowFkDlDDoH16qoYcNDGFs1gSur/MKnAU4ivywk6sFq/loj+
dt9eTNUPvyZKRxxq/Gnf/vPhSxnDMJgBOVcyvhj2zNPN8eV6gkJC5KNqN08sszLm
jtlVK8n9JbXMRDDRg6bXWpEl3sQ8tOv8eVZ0P+BU+YSW05LT1Jwf+Ljur2lyJ6eo
NFlMwNL0YDFi/RL9HZvmncQj4PHu4jrQIHw8vRZ0eiI/oEXsJx8a5zfnm0kgANS5
lRvLvJsZ166NZjJaFmzrrE+cj7Cn9VzRy7Yv4Cg/4BqDYfT8VvRjkWMHdXF2jj3D
lV2NMcKbbSDjP38D5fYVLnpxPRqNAW92ZZBqUphcuvp6ajcyXSinCuEGuI8k9YMj
BAmgvY59Jv41p9exq0Z4Zk5GVrNlJxC9j9lXd+ii6UKUjgtTjuXaXQSKMaIbiWHY
VxFcvTzU7OcLE7NZVkywUaLT2N0gIzcVeyh+oDLAdv133VXNc2Cav50wRjug4d4b
/mWZbd65YN+N70vtZY98
=0Yfo
-----END PGP SIGNATURE-----

--qGAgqvhehk6hdkudpXXcWivT7L51nsl8i--
