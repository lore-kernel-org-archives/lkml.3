Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaB0E4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:56:21 -0500
Received: from ozlabs.org ([203.10.76.45]:50853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaB0E4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:56:20 -0500
Date: Thu, 27 Feb 2014 15:56:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Paul Bolle <pebolle@tiscali.nl>
Subject: linux-next: manual merge of the pwm tree with the usb tree
Message-Id: <20140227155613.16a690cf5423d4889d887273@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_15_56_13_+1100_W_ZJjhlM=7NYIzxe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_15_56_13_+1100_W_ZJjhlM=7NYIzxe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
arch/arm/Kconfig between commit f6723b569a67 ("usb: host: remove selects
of USB_ARCH_HAS_?HCI") from the usb tree and commit 557fe99d9d49 ("pwm:
Remove obsolete HAVE_PWM Kconfig symbol") from the pwm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index c85745d2d20a,cc6ce44064a2..000000000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -628,7 -629,7 +625,6 @@@ config ARCH_LPC32X
  	select CPU_ARM926T
  	select GENERIC_CLOCKEVENTS
  	select HAVE_IDE
- 	select HAVE_PWM
 -	select USB_ARCH_HAS_OHCI
  	select USE_OF
  	help
  	  Support for the NXP LPC32XX family of processors

--Signature=_Thu__27_Feb_2014_15_56_13_+1100_W_ZJjhlM=7NYIzxe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDsVxAAoJEMDTa8Ir7ZwVPMIQAI9m/jUABxm4d2aCjjrFVTfA
nF7YGPTSQlGxMkYzNHKHrHBXtOVJKMF5KO+eMFNjo7SzKFkSGl9BN99xQq/DeYb9
qLXrF9UzeyKb40Iml6LWzv+xfOPIYYYKYcJwc/V/9Bk6lr9ihHWPNL7B/Dx4O+Ys
IYoS9Aq8aM2aYIbbWI32cnBH11ucsnSUfxZElDLoNA+2eD++nF4b60AA/3whf1gF
5oUXkuGYzrZkjf81pBff9+9fw7/Su9+DOForS8q65rbEBd1YBjW4ldXwDYZUg1Wx
3gR7oJnaIuyp1vQUR3c6piKXxx3JQT+nTo6CGq+MYgudsrC8D3DkTKaFI1YWTsha
CiBYVehNNZiJJwx8o7KmMu+8SRkq/KlmFC/d5Gzsqakx0NZMeLdLoWSCDEhBzTqe
iZBUH1UqsFdwXwu8PebPu4Nbi5FjWRiVMLwTcbgtLdeAovdcoek7Sp0NjxDc2zkh
+tMs79sPaAJop2sOLNKVlrKRsYRwaPEEGEMhChWSPwfyNLUQXiZuFo8kaxnrg5SF
7GkY/dET3FUp0nSLAJXqJpkrWG8v3vfHnm3WTL0apSTti3c06C8OV3PI1u7An2n0
tii9FpYc0AdLQqqPI1j36MAf1lFEgoM2911KmBwmGFDW8r4jk1K1DhXfpw8L0kvu
QiH7dTYQ35MK4e4UnCLD
=t6V5
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_15_56_13_+1100_W_ZJjhlM=7NYIzxe--
