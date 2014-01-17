Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaAQFSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:18:44 -0500
Received: from ozlabs.org ([203.10.76.45]:42695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaAQFSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:18:41 -0500
Date: Fri, 17 Jan 2014 16:18:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sherman Yin <syin@broadcom.com>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: linux-next: manual merge of the pinctrl tree with the watchdog tree
Message-Id: <20140117161834.797f4a7e019e51e756750613@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_16_18_34_+1100_UR3kPPH7+LFk9dCm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_16_18_34_+1100_UR3kPPH7+LFk9dCm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/configs/bcm_defconfig between commit bd90ccd42c5d ("watchdog:
bcm281xx: Watchdog Driver") from the watchdog tree and commit
54b1aa5a5b16 ("ARM: pinctrl: Add Broadcom Capri pinctrl driver") from the
pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/configs/bcm_defconfig
index 176e842308a8,bede51171d98..000000000000
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@@ -125,6 -126,4 +125,7 @@@ CONFIG_CRC_ITU_T=3D
  CONFIG_CRC7=3Dy
  CONFIG_XZ_DEC=3Dy
  CONFIG_AVERAGE=3Dy
 +CONFIG_WATCHDOG=3Dy
 +CONFIG_BCM_KONA_WDT=3Dy
 +CONFIG_BCM_KONA_WDT_DEBUG=3Dy
+ CONFIG_PINCTRL_CAPRI=3Dy

--Signature=_Fri__17_Jan_2014_16_18_34_+1100_UR3kPPH7+LFk9dCm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2L0vAAoJEMDTa8Ir7ZwV3vIP/jMkzwEFYfkYkuKz7QJuJ9s0
JRapV1IrKLpzTG5yfZP4OihnEv1YifH40IcYR4dhZmgtCw+v3wJdv0apxSZfBhte
ux43gmW/6+Tmf30WhA981ztkuhvIVM5BtSNr6Txgr3Pavg4xr0l1LgoVdK7REXQq
8biXa70pY1p0NlRIMbBbOtKPNC8k8TySVCpN9f9Pl0p0rdLNJNE8l8x57vbZxnkC
Io7DAlSgfhU0PdklzgLPqxMfMY/rpuVCTz2ZQCrLRt+uk6yGBrSS5eWu7QrRtw8d
NlrgfziNYoVvEYOQZ/+OZ+D56rLsgDQK/zntbw2oKlwb22O/EpJotGLqkFqMwj2Q
EYRlEMDvtfgewtf2F0DVUBykH2Aj5WtExegwShtHEghxgrz/yWCeVERV9rSywDMi
UR71P4PSmo3UAdIDuGKyGXiHGDAe5mrbX/9Z4vJT4EftyotiHjJmIV/+rJI+g80m
pWkAysnJE9gS9YlgRBcpoGkhX6EEVRiIRnXFS84ywkoh0g1Cl6ClNcjDNrenMo8c
SaE+4I4gz1O8lMGwtAJz3Gg5zJxTvShbzuu3blSbfo7aTxwrKAI2Bi0fZSW/w9zt
R+6G7DwGCZ/1z/TBfCaqE5rq5p0zp9Xf7Y+dTXWv428zITo/bzg1mG7zo+JNJi3o
S/67YrmdWM0jr/OrpG/g
=FfFY
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_16_18_34_+1100_UR3kPPH7+LFk9dCm--
