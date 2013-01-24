Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3AXLRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:17:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35637 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969Ab3AXLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:16:59 -0500
Date: Thu, 24 Jan 2013 19:16:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for v3.4
Message-ID: <20130124111651.GN4955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CaPKgh3XHpq3rEUV"
Content-Disposition: inline
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CaPKgh3XHpq3rEUV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-fix-3.8-rc4

for you to fetch changes up to af4ca6a8086505d135676f9c904c9d67cbb8d81b:

  Merge remote-tracking branch 'regmap/fix/debugfs' into tmp (2013-01-24 19:04:16 +0800)

----------------------------------------------------------------

regmap: Fixes for v3.8

One more oversight in the debugfs code was reported and fixed, plus a
documentation fix.

----------------------------------------------------------------
Mark Brown (2):
      regmap: debugfs: Fix seeking from the cache
      Merge remote-tracking branch 'regmap/fix/debugfs' into tmp

Nestor Ovroy (1):
      regmap: fix small typo in regmap_bulk_write comment

 drivers/base/regmap/regmap-debugfs.c |    2 --
 drivers/base/regmap/regmap.c         |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--CaPKgh3XHpq3rEUV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRARf4AAoJELSic+t+oim9edkP/3R+6kbVo5eZxFQ/AqSriAUq
JX7d9RFFFkX25oGZfKPjBL0KGmQCPWiKzzMSMV+PTundMbJt0IvHlehceVwvNdAG
F5L4mwVgGm5dgNHl59xIi+m95K0eNPJ4CPSZ/ikjxEGrweg4HhDHsU3zQWLhBcbT
6F1Y2hR1Vp6MNo5nGqy0rLihEng8hy7qfoB/YNNCZg5C8EkDLdibLjwgc9dGgmMe
okCXnnQ76GpocMMVt5cSvPoSqB5qeADLtd144F9hGqEiZml8/LuUW9Mqt8jGH1kj
Tyj1wilTm14YJ/1DvwWjJAdG3rUHhuzEnDX6zK6x2344Op2Mi+5JX5AfFgni4m+9
2fz93a5SCQ0mP4ab71EpBUMLLWANSrkPnAPDlgFSuvcJC0r9XqREosSPeC9zTPCg
+hXOOM1RjxDVR9XG2er/m+8Qh8L1fa+cvg2dmHpK60ZhBZxlQ3y7GTVYOLFFct5U
yHKktbCYNKA0F2cgtlXF3u6GxSWbkKvbxOjBTxcKIRtgS2sRXv4dEW6o142C1k5F
/Lt2mc/1mv94F9Uz0L6SuwVNiTpb52fqYGvkC5tHSxfxDHxDlm2JL34PvPf4ssg6
ugEkbpxQv4DE9mmH+SYzjiiu1mG/0mMkKzomfZb2G4/mfXSMJFgmb+VrwvdVs88D
iUV07kk+3UUYwcVjQZ97
=swmN
-----END PGP SIGNATURE-----

--CaPKgh3XHpq3rEUV--
