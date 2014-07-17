Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaGQCGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:06:40 -0400
Received: from ozlabs.org ([103.22.144.67]:58902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaGQCGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:06:38 -0400
Date: Thu, 17 Jul 2014 12:06:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-ID: <20140717120631.4bc75d13@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/rVWd7GgWbMHPOh.rAriy7QI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rVWd7GgWbMHPOh.rAriy7QI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got conflicts in
arch/arm/mach-s5pv210/dev-audio.c,
arch/arm/mach-s5pv210/include/mach/gpio-samsung.h,
arch/arm/mach-s5pv210/mach-aquila.c, arch/arm/mach-s5pv210/mach-goni.c,
arch/arm/mach-s5pv210/mach-smdkv210.c,
arch/arm/mach-s5pv210/setup-fb-24bpp.c,
arch/arm/mach-s5pv210/setup-fimc.c, arch/arm/mach-s5pv210/setup-i2c0.c,
arch/arm/mach-s5pv210/setup-i2c1.c, arch/arm/mach-s5pv210/setup-i2c2.c,
arch/arm/mach-s5pv210/setup-ide.c,
arch/arm/mach-s5pv210/setup-keypad.c,
arch/arm/mach-s5pv210/setup-sdhci-gpio.c,
arch/arm/mach-s5pv210/setup-spi.c and
arch/arm/plat-samsung/s5p-irq-eint.c between commit 2fd48f94426d ("ARM:
mach-s5p: get rid of all <mach/gpio.h> headers") from the arm-soc tree
and commits 36278bb98dc7 ("ARM: S5PV210: Remove support for board
files") and 2722091e711f ("ARM: SAMSUNG: Remove remaining legacy code")
from the samsung tree.

I fixed it up (I just removed the files removed by the latter commits)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/rVWd7GgWbMHPOh.rAriy7QI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxy+sAAoJEMDTa8Ir7ZwVveYP+wdN4yltysXSwRKrVZGop1ES
GgZDO1EwkutBg7AjneA4obb+s9x63YFSHSMTjKSZxiukJGhLfE7VcPVhIbX1LYmn
7pYgIKB5k/KWBreP3pjm4ymef3AyrIB87vfV2SxD3TlCN1LmiASk8YPmBqZjNCVQ
ZBWkGwEE6RFFmMyE7EvPHrhPSAdfsQzaFWdbaroysiA+XGI2umilr2xacSWOgxqM
cl39/nifmOrhOrhcShcBOIsNGV8PPCzCu2TF7OAZBWViAseGLkmyraQTwQIXaDhV
AAWVTifMvwvB3xTWSa3+f5Fzlnjg7cmt4rU+lhGfhFXanCqQwN+f26loy9rLJSUL
dEKz+j78rqkoxp/u1yo1SFmNC/EDsdmeRdszCuzelxUPTwAf+KBnZbuDe8eEKXCY
BuA2MnMGMxbERneg2WOP6TyU0WuWaWUiVvW2rw39biMQNETPDZXPS7ZolSFVaMj0
zjLJji2iYrJAXj2x7ZA04RozSQrg/KU5IhegIhsI8eySvGdtiFyVV1VbhCMmFXGJ
WFFIly4noTfuvRdXJ6K7FFdJ+4k8kipQSuJwP2UpMrpRTOfHQjNS5bazIcXtiKM0
ZzvMUS2H0H1F8pa0q949fYWlcKzOUSAahLAtHu0YQLeH1u2T8iaEvyZDUYc1opml
S8LCe+JNiS0ncvvN+lV1
=Ndny
-----END PGP SIGNATURE-----

--Sig_/rVWd7GgWbMHPOh.rAriy7QI--
