Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3LJECL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:02:11 -0500
Received: from ozlabs.org ([203.10.76.45]:51111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3LJECJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:02:09 -0500
Date: Tue, 10 Dec 2013 15:02:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denis Carikli <denis@eukrea.com>
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20131210150201.c99abbdcc7eb1a20d39dafc1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Dec_2013_15_02_01_+1100_Ww1C8ciZ2m_TqEWi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Dec_2013_15_02_01_+1100_Ww1C8ciZ2m_TqEWi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/fsl/eukrea-tlv320.c:28:28: fatal error: asm/mach-types.h: No such=
 file or directory
 #include <asm/mach-types.h>
                            ^
sound/soc/fsl/imx-pcm-fiq.c:31:21: fatal error: asm/fiq.h: No such file or =
directory
 #include <asm/fiq.h>
                     ^

Caused by commit 436aa86f0414 ("ASoC: eukrea-tlv320: Add DT support")
from the sound-asoc tree.

I reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Dec_2013_15_02_01_+1100_Ww1C8ciZ2m_TqEWi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSppI+AAoJEMDTa8Ir7ZwVkFMP/2IPtJsEO/6UTWYJVdB7Kpqx
IHL1rRvr8Y02tIu9b389hhzKeleoQRikDGz6lYhiGwA6F4BlZwA69CTCk7QWKTSN
QBo+ClrtSsA+aWfkM8aZ0lnzc6C2rSknzDjrNibHMl4HGQ/C9X1r7ov0tnMiIOJ6
RATonfRFmMz48E4jpOhEpooL8Zv4+6VeXEoQjYiq10tIlLHKLOEKHknwMc8e/AHI
33aVfveGlUb5LpsaT6QjtmfLNdwcp32xyc6FW07wqhSar2fSKyB4C1v854jCAnl9
BKCd5q0Byf3lTKnS/EIFXE/2mEs1i/TsPPigjfM67RoyXmgpBcjtoSXHv3vuxa62
YmsuMtKiAEY7aKjNGwHxp7zNnTnDCkt+1cYTH9WCk5vE1CKmFvI4T0P4UEb4q1vB
BATxGmKmj/yT5plmIFQNzAScRJZP9MRQLBBtSNFo5sKlQRbPSO4qiFYr7o35OZVz
AdiMQmBjl1i0U0KwRFsGpjlIhd+3k/cE1+BFHCqhaNKW4hsZyUxvnmbd5IZCDCSR
3nbLNvW8JguFuYi3uaXmCTVWLjGI01eHIurSBOCuaaTdNXiblqhK1MgrH647Il3C
4n2Ow66PdbdGN3QCGHg5bWwecvqK3oCsN6ZtVIDjzIOtwV1XCqJ3d2cDo7ZpEqqR
wgELEWdv6kUHlk06EbiE
=2LCa
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Dec_2013_15_02_01_+1100_Ww1C8ciZ2m_TqEWi--
