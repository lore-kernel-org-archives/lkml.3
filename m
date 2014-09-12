Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaILJKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:10:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33750 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbaILJK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:10:27 -0400
Message-ID: <5412B880.8000705@ti.com>
Date: Fri, 12 Sep 2014 12:10:24 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.17
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pNk3rP8Mb3rmjBn01mx00r2JIUlrv4Kpg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pNk3rP8Mb3rmjBn01mx00r2JIUlrv4Kpg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c66=
6f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.17

for you to fetch changes up to e4cf39ea473329dfc07de1246f97d27b7fc96f79:

  video: ARM CLCD: Fix color model capabilities for DT platforms (2014-09=
-12 11:45:10 +0300)

----------------------------------------------------------------
fbdev fixes for 3.17

Minor fixes for amba-clcd and video DT bindings.

----------------------------------------------------------------
Pawel Moll (1):
      video: ARM CLCD: Fix color model capabilities for DT platforms

Tomi Valkeinen (1):
      video: fix composite video connector compatible string

 Documentation/devicetree/bindings/video/analog-tv-connector.txt | 4 ++--=

 arch/arm/boot/dts/omap3-n900.dts                                | 2 +-
 drivers/video/fbdev/amba-clcd.c                                 | 4 +---=

 3 files changed, 4 insertions(+), 6 deletions(-)


--pNk3rP8Mb3rmjBn01mx00r2JIUlrv4Kpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEriAAAoJEPo9qoy8lh71rfUP/3bT81nkZ3un+HQ+6nIE9sm+
WKbAUeOZ4eFh0Y07ZDy+RGKTKlU36eD7cUpa6nz6K3Z3W1syUOiGp1i9zJf2599x
qY3UwY6oQB0RFkM9wx5zJlCcf9AXGK45bVdsgrz2yR5Njy+0DiiHOJr4T3xCuGWe
eyV3ZPIxZsVBHn3Pr1yCqo8ao1O13d13aXDWIQ0Q4Vq7ieUCSLP4T8liOvuEKy2A
xvmIxF+Y4St7D9fLoaBj+dNNyUCLP2bJyNlvz3B33ftEEu0jI/yR311NADmja4hf
M+eCiC9FI5M+RkyFihLh2sbXJJOgVMKeIM/ZQmNztwGEFY2jcTIa5xzjkoWBR+Yz
Ebogx09JD3jEdXoPaTHQroo77JBLgYPrYuwWuVfVb95s2GeoX81xGjMr+Mr5OqiF
jAzgCxxer15t4uLsMmo+I47xcSaH8JTogmAUZx6pKCnRIleNbLQQZYeYgC6A+keL
Kfq8ZhGbmcJD+xUTaNnXDCcDWGl/T0uB9WoglgKSRfGSAnQfG2/bSet/DQ9sMK19
Brn+Hp3aXKig6CvdJOH1rJffFDX1YhFAt5OWW7ssYDLP9elgVNsIvEteDGC+RKYz
EeKzKPtimuFwcgOKwOGX/PCaXShgN3MX0V8RuZRl5GALr5j7ns1JBTw/N3npomAa
oK0PnPETzGNw/z6x4suU
=1Vh/
-----END PGP SIGNATURE-----

--pNk3rP8Mb3rmjBn01mx00r2JIUlrv4Kpg--
