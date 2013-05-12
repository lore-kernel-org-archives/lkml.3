Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3ELOnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:43:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47779 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3ELOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:43:13 -0400
Date: Sun, 12 May 2013 18:42:49 +0400
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130512144249.GA4046@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

for you to fetch changes up to ecdd483531cc72aecbc711c75d3e29cf1502240f:

  regmap: debugfs: Check return value of regmap_write() (2013-05-09 14:32:36 +0100)

----------------------------------------------------------------
regmap: Fixes for v3.10

A couple of small fixes for the debugfs code - make sure we report
hardware errors back up if we encounter them and fix the display of
register maps that make use of striding.

----------------------------------------------------------------
Dimitris Papastamos (1):
      regmap: debugfs: Check return value of regmap_write()

Srinivas Kandagatla (1):
      regmap: debugfs: Fix start_reg calculation

 drivers/base/regmap/regmap-debugfs.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRj6pmAAoJELSic+t+oim9h1AP/2wYJncLuPgoiaKT1V2V5qKj
wv1urQv/Cxp6MXWB1L5seUPVsMCvEpbOj/nZ4nXdIL175bOk+uluRbyUk0HjrG7J
hjuCNuc/QcS5X9KDAaDDBRtTnfVHnOKPylg1Xjeh+i1BSSNdoaaDdISRTIFUdrij
mKViNhC7w6kw51ImbWP2mWWSVp9t4l/imFI+2FNso5UpFy/GuGF63ajAupQR5MoT
SC//wQdZHdFzD0FqGXaQwNGuFBpwbBzSvZJbrTfVPpFY20pQw3HZkrIIyisq57Ah
8OXsdn8a5oERGs+E+NH2umVgraTRuvx+Ehb+YV7iY8X/ZjWTANZJlMTlsGx0WL1e
LVJdTYESbhP4/pC6h9EOzKndD/WbKx7GFVeP1DeIA/jAJdD2hdmX+7xVN4BWgBAR
lVfvZW1KRJYtTl8r+kU3qnPBEu2IcaYejU7Qx07UxvjWc7xLf3gXDIPr/1h8AcQL
vQy2G7V0IRnnksVIVBTEZjW6UiGnzALcEepgwFA8bjmlj67AVNX3F409msAUdgVf
aGIdQDwbabRMZwly/HrCf3BM1rvkNw5h0Z7/YyVey9jecBrArgzI1tyHo+IUsA29
kwZemo+iCkjIX0UI/4lV7GTKge5nrGeOyLBmxJcKPu7dhdm9ipfZ0DVjOzfDOu00
PbkIw8oPD5Lx+XX7vfu3
=KoI0
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
