Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBXCiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:38:00 -0500
Received: from ozlabs.org ([203.10.76.45]:54936 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaBXCh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:37:58 -0500
Date: Mon, 24 Feb 2014 13:37:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: manual merge of the sound-asoc tree with the mvebu tree
Message-Id: <20140224133752.bc1ffffa4e81edb76a76e555@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_13_37_52_+1100_nRDEJPUBe6s2wajY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_13_37_52_+1100_nRDEJPUBe6s2wajY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/kirkwood/Kconfig between commit cd34edc2eab2 ("drivers: Enable
building of Kirkwood drivers for mach-mvebu") from the  tree and commit
9a0d5113ac0e ("ASoC: kirkwood: enable Kirkwood driver for mvebu
platforms") from the sound-asoc tree.

I fixed it up (Probably incorrectly - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/kirkwood/Kconfig
index 106e2e22fed2,2dc3ecf34801..000000000000
--- a/sound/soc/kirkwood/Kconfig
+++ b/sound/soc/kirkwood/Kconfig
@@@ -1,6 -1,6 +1,6 @@@
  config SND_KIRKWOOD_SOC
  	tristate "SoC Audio for the Marvell Kirkwood and Dove chips"
- 	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_KIRKWOOD || COMPILE_TEST
 -	depends on ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU || COMPILE_TEST
++	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_KIRKWOOD || ARCH_MVEBU || =
COMPILE_TEST
  	help
  	  Say Y or M if you want to add support for codecs attached to
  	  the Kirkwood I2S interface. You will also need to select the

--Signature=_Mon__24_Feb_2014_13_37_52_+1100_nRDEJPUBe6s2wajY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCrCEAAoJEMDTa8Ir7ZwVNeoP/2kCkdU88NiqZ9rT5SNH0rgP
HOn45Zr77xwqfLEIZSHVSSgSOCQ5k86wpwuNdIQ0DdZkmEMxlAUHMrhEw7C1Bz6t
Nna/e+BEQj75ASxqJG3HkT0eetvedYoodLXV4iXLlOslIGlVeQIWuH2+rRr93OiF
iea8PyF/hMsKuCH6VfpiVegGGeR0cqWy4HV/qob1ZyPfvDbGifwQnkPJ9TqaBt8G
oT+oD7xJ3KcILNbX9YdT5iP9daQ/a1+z11Y322Ox8uRV9Vjto8QO25gw9myHD5bZ
Xaq5dvfdAc/tSuPZt3JW5o5hhvlUQRt1M0nkIZWT6fjvvWQEm9NZp6w76jFER21g
P3V9ghRZOcZsT3G+vZBtna/YOSkCy/KSDzgBMAh03olqMpcI3eKK6iEtxuRQY08D
JXSqIBFPdGxHfHOVfuDfBDFZuaZaTNTmeTUAhVgKONW9ajobmk2X2tCVHfThjQ4U
0gVnLunpkybgmlO2//wXjt5rCiQXRujZ7DhN68iCx9SnAOC6+DxJElHxpYov1wjO
e9LCaUoYIFuu96q1tBtlZX5TfuxGjoWrZftsA52YnYjq5Av9rkZPxAWGhxBFFg8T
q9vNoI2PMS0/Z5sXYaMYKKyrqvwEg1zhoHAQLKVgJxsEN2is9YCDV9IWGw6M5TYS
/R4kSl9UPOB3XGsH7J41
=vQxk
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_13_37_52_+1100_nRDEJPUBe6s2wajY--
