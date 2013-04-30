Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3D3HsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:48:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36704 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab3D3HsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:48:00 -0400
Message-ID: <517F772A.3060806@ti.com>
Date: Tue, 30 Apr 2013 10:47:54 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning while building Linus' tree
References: <20130430095527.fd4c5ad48ece70c567991416@canb.auug.org.au>
In-Reply-To: <20130430095527.fd4c5ad48ece70c567991416@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2NDKTPBIXPODSVKJHEEML"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NDKTPBIXPODSVKJHEEML
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 04/30/2013 02:55 AM, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
> produced this warning:
>=20
> drivers/video/ps3fb.c: In function 'ps3fb_mmap':
> drivers/video/ps3fb.c:712:2: warning: suggest parentheses around '+' in=
side '<<' [-Wparentheses]
>=20
> Introduced by commit 11bd5933abe0 ("fbdev/ps3fb: use vm_iomap_memory()"=
).
> Sorry I missed this in yesterday's linux-next.

Thanks. My bad, I should have checked the warnings also, not just if it
compiles. Sigh...

 Tomi



------enig2NDKTPBIXPODSVKJHEEML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRf3cqAAoJEPo9qoy8lh71DnsP/3P2k97ldrx0tCz2ztx+1FPF
34POIuBKwlOi2VhzVXBQ6ZnXlo8pGI6BaNkoDq0t1SrqLjojNihSCLwd8Wl069g9
/hqdWfy/AlAIBHWWLvkz3DW2b/rCgFqoepfvVFtWU8RPJptcGOlitkaIXEZzdlUV
KliHW005+eU5ns2qC3prEj0QuealS24ZRWNeKb11R0EuokQKtw1pEjkWYycxOHwP
iygtkZjrahwaXdbo/q4CXojGZwBMTl2qrfk1r0HF8hsersmmQkW140cpth7b11Ql
2CI/07KQSH1Kgbke8j894lhIbuBAmUmBysYIAzNlaXsB8e6Jwsfn83vg6Iuslvbw
61KoR3w8c9BLjS0DL7ODzAJEX7RLzpt1I8DBQjgSLz4lj9e0uFLlUDRU6xoNQU3Y
/aENSYrsvGfqEa2Ny91C/a3DTRB+fm2tqXA2FptQBGgv9VVcpkBMay2XKvdNxr03
anPNpnx7Z29Z4pA97ds9/iV446AiwPewr2pgDGHpv89xZgvXXrlkrGmkqpdK3Lxx
P05X3DJgwv6cMY8nRxi4Qx8kv2WdiI8X4iwYmSkNZPSiwpTy+DwX6qaVhWfJps7I
8hMbC2DXcPGDmDJNRcYCoXC//3HhW+5MiaSLVHS7cLt8Vs/Bfm4R3c3ZeoNoRcIE
RFMHYgphbl+HWMScml/d
=z4l9
-----END PGP SIGNATURE-----

------enig2NDKTPBIXPODSVKJHEEML--
