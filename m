Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab3CGCk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:40:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42670 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab3CGCk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:40:56 -0500
Date: Thu, 7 Mar 2013 10:40:28 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap update for v3.9
Message-ID: <20130307024026.GD22554@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Content-Disposition: inline
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit a2b37efc4e2aa76a5be29bbde8a2cd1c9c9066bc:

  Merge remote-tracking branch 'regmap/topic/no-bus' into regmap-next (2013-02-14 17:11:09 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.9-rc1

for you to fetch changes up to 283189d3be56aa6db6f192bb255df68493cd79ac:

  regmap: irq: call pm_runtime_put in pm_runtime_get_sync failed case (2013-03-01 14:54:16 +0800)

----------------------------------------------------------------
regmap: PM fix for v3.9

A simple fix to stop us leaking a runtime PM reference in the case where
we fail to enable a device.

----------------------------------------------------------------
Li Fei (1):
      regmap: irq: call pm_runtime_put in pm_runtime_get_sync failed case

 drivers/base/regmap/regmap-irq.c |    1 +
 1 file changed, 1 insertion(+)

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRN/4KAAoJELSic+t+oim9IVUP/0HLECkkHcsc8qUXdDxfjtFY
jgrW0D1xYeqqis3wjP4dC5BCQvS1UhAydGvJlT0eoG7/pTcF2m0njo1YTOCJvsb+
w16TtVripP29a9UE21sfQ15ZJvD5b0v5ru5A4D3lockAO7rY/gqjQ3UGGio049jX
6tP5o3FhwMBpubm8mar9rhiHZU6SlrL8TsfTebFAq83v0lokoXEkceNevIRB8KkG
0AMeXbiiTuQXYMnMaInaWmfMrgieTFsev64s3NJM10Pc9e3/KUU/x9XWlEVQ0BMW
M8g7KlQsnHbNsX1CvUyCJUdhgKIcQiwQ6jlLVxAAP2vnRWv2dpXvlMmTbud+4xx8
Qkrd+1lv67+eqHbMUiOXjLFdvQfGkoNXxIUgcvYtULZKIUD/bvsiM9EFAGVXr/cx
CFQgRy/Y89U2Z2DI44Ghlphz6LyNWDClASjihofw9s6sDa2qPFqU1Hg2EAiRY370
G3W+PhlQixD9qaNpnFx4A3S0quO0DjguYoq800yJtvh7tNOa1HuZpwzLu4jInrFK
R4E3DAiu5R0yZGI6lOaAlVYl3FFm0l9MIFOoA7HkfMzjx9C89tXOBui4pmpwEZe1
D0YJZyUM+WQi5f4WEwcG4R6aREL7GgACzuFRMruiUzWhrdTSiBQvqA6I2PtenE4+
ouHcCYeO7A3InuCFsRjL
=RRic
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
