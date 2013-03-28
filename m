Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3C1M0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:26:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54097 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab3C1M0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:26:43 -0400
Message-ID: <515436FD.6020004@ti.com>
Date: Thu, 28 Mar 2013 14:26:37 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.9
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigCDF8D88454D26DD074F8D15F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigCDF8D88454D26DD074F8D15F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Since Florian is still away/inactive, I volunteered to collect fbdev fixe=
s for
3.9 and changes for 3.10. I didn't receive any other fbdev fixes than OMA=
P yet,
but I didn't want to delay this further as there's a compilation fix for =
OMAP1.
So there could be still some fbdev fixes on the way a bit later.

 Tomi

The following changes since commit a937536b868b8369b98967929045f1df542343=
23:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git tags/fbdev-fixes-3.9-rc4

for you to fetch changes up to ff588d83bf12fe05521a64e85dd4e2b848c0b20d:

  omapdss: features: fix supported outputs for OMAP4 (2013-03-22 10:14:32=
 +0200)

----------------------------------------------------------------
* Fix OMAP1 compilation
* OMAP display fixes

----------------------------------------------------------------
Aaro Koskinen (1):
      omapfb: fix broken build on OMAP1

Archit Taneja (1):
      omapdss: features: fix supported outputs for OMAP4

Grazvydas Ignotas (1):
      OMAPDSS: tpo-td043 panel: fix data passing between SPI/DSS parts

 drivers/video/omap/omapfb_main.c                    |    2 ++
 drivers/video/omap2/displays/panel-tpo-td043mtea1.c |   13 +++++++++++--=

 drivers/video/omap2/dss/dss_features.c              |    6 ++----
 3 files changed, 15 insertions(+), 6 deletions(-)


--------------enigCDF8D88454D26DD074F8D15F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRVDb9AAoJEPo9qoy8lh71apQP/1ak58UeAItvJw+pZFz5/yqS
8AniWHlLiHSbbhIwOJjk9Unji74GIH2pg6SfCNPdpov/W7mgVC/7zqLRwOhUOmjP
nG2pWUCh8lZCDQGpUvtiCYpAQpT7R3IZj7uH1oEoJH9GgnIwPdSc779PGfz6bZfR
zQnJT9NSbdVczJVZef4jEIw40l4CZdG0H1KZS/dQPD3ikSwUrrM7FIRcGMMqwiFM
pWPIiu4yWQECyG728++MaPJ4f5Rm3tovIaMy2e4KVrehVKSiohkZdhHwgBTIfwPz
29xy7boocb/DUDtUFLMCaP9jfiL/Au9OgkMOks41bnLFLULJB7Gi7PhaYzFYyRZt
i5p4HkndI2t2syYyI1F7h5+8k3O9vVNuJKdrbBqzO//QeT1AlRa7Ume/Xtnpjnhv
2lXylSoupG2WTUtJCNoc1gQ+/WD5D+qIG61YiNFqrOqNeKLG+zfn2ASClBDDZl+z
aBO/oFYqyZboPvW2sjAnx+su8AsJSDMrcDJIf49YXZhszd0NM+dHDxroy7XvpRCv
GJflcHmgXAjLuQYaIeyXARsM2JhhE0SHauKL4ZNSK9cucqpQHxfY4jYgmQSXHBgo
1pz/nFuAhY1D6xGD2a+kJwOsl+qIcX37DpFnxjJ/G6GCx3kAo6QeSuAPBX9PC4ti
4UsL9aedmKPCq5EKPCoW
=VotD
-----END PGP SIGNATURE-----

--------------enigCDF8D88454D26DD074F8D15F--
