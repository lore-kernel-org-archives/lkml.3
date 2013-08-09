Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967073Ab3HIKoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:44:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52406 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965852Ab3HIKoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:44:12 -0400
Message-ID: <5204C7F7.8050503@ti.com>
Date: Fri, 9 Aug 2013 13:44:07 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.11
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="PQsmIe6CABxkHtWGvEervURDW0PDALFX1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PQsmIe6CABxkHtWGvEervURDW0PDALFX1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are hopefully the last fbdev fixes for 3.11.

 Tomi

The following changes since commit 7808e3291e1e101e9ad6e8263119c4a2abae05=
ef:

  video: sh7760fb: fix to pass correct device identity to free_irq() (201=
3-07-29 11:25:03 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-fixes-3.11-rc5

for you to fetch changes up to 70a0f6032985f156bd7e957cfec99c3dd3d592a2:

  ARM: OMAP: dss-common: fix Panda's DVI DDC channel (2013-08-02 15:52:38=
 +0300)

----------------------------------------------------------------
fbdev fixes:

- omapdss: compilation fix and DVI fix for PandaBoard
- mxsfb: fix colors when using 18bit LCD bus

----------------------------------------------------------------
Hector Palacios (1):
      video: mxsfb: fix color settings for 18bit data bus and 32bpp

Tomi Valkeinen (2):
      OMAPDSS: analog-tv-connector: compile fix
      ARM: OMAP: dss-common: fix Panda's DVI DDC channel

 arch/arm/mach-omap2/dss-common.c                   |  2 +-
 drivers/video/mxsfb.c                              | 26 ----------------=
------
 .../video/omap2/displays-new/connector-analog-tv.c | 18 +++++++++++++--
 3 files changed, 17 insertions(+), 29 deletions(-)


--PQsmIe6CABxkHtWGvEervURDW0PDALFX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSBMf4AAoJEPo9qoy8lh71BgcQAK0zYyJjPEOFYsVjO8dqjbsy
DxLWoQC6+IoeDDZ1NmP4JFj2tzF5YTW/z1DaihOc8nLyHeiWSqsi2lyiVPAMVto2
mRC0zyjvFxle9J5xqHtVPLUj3mQiTTngEBegn5rALSYcJsDJ/J1dpF0ISuKwPXqm
z0BFBnuk5T5gnn/R4ilexsT77PvhuI2W2MedEN8KHcg/KQf5D3KdhWDDrUkdAFdF
nDzncbx7t9bToBiE5ZiN1i9TuMK4fUkzxEONoLJDYwyEYbj+mYgDS7VKumL2GPrG
W5OXMRFKejcLPp6J5ajSkTWXqac2kCabtLJv7+34A18R0AqwFg+f2BDDZ504/ah1
3+LzctvQf9kJ28j/tDkl33hec2l1gtrvoaM0Hd0hxU5iq4xpcQttXQHyXQVWUz6C
ltPugXhEkz2wSg+dTDrrufD8KQgtobdD6Dt+ncrqmkvEfH0qAaZhLZE1GecSyFfg
JoJGvoiIJJzznUKW02Sw68GLOeC1syBsmFXolQ3yRyGgu3pgf03WenilmJCvT6FN
32Uhp4hNz4m45UIrf5LE4n6HmVcpSSlSOwGt/h2Uz95wCzqRnn19XEJUVlrQvFEL
bVho704J2IVZcREDSZhnNdS0GlWv0+Zww4b/GpUhxfpCWrkABnt/3nb6DsFYFehm
U1vtuCHsspznWvNSIPy/
=wxWe
-----END PGP SIGNATURE-----

--PQsmIe6CABxkHtWGvEervURDW0PDALFX1--
