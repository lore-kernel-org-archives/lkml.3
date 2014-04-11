Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbaDKKFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:05:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48569 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:05:02 -0400
Date: Fri, 11 Apr 2014 11:04:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140411100448.GN6518@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2DT8m24oj8Onh3Jp"
Content-Disposition: inline
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap fix for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2DT8m24oj8Onh3Jp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6cfec04bcc05a829179c02584bb55f28fee03795:

  regmap: Separate regmap dev initialization (2014-02-16 09:53:02 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.15-nodev

for you to fetch changes up to a7a037c837cb0f9d011cb3ca6e6837989986570c:

  regmap: adds missing braces in regmap_init() (2014-04-01 12:09:08 +0100)

----------------------------------------------------------------
regmap: Fix for nodev mode

Add mising braces so that the nodev mode actually works (which was a bit
of an oversight).

----------------------------------------------------------------
Daeseok Youn (1):
      regmap: adds missing braces in regmap_init()

 drivers/base/regmap/regmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--2DT8m24oj8Onh3Jp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTR749AAoJELSic+t+oim9ZTkP/RY8RY260UxBVk0wwhU7KsDR
j5fJIyVso2F1etBWeqOZ46Xn2xL6o4mrAVvrRGWmUwJZADMWdxHIeBjn89CyqtC6
Cg/9jUxKiiT+1dlEdBB2Is3ZqSE2TMpYoEjfHuFlBq+5LkP62XUM5sQQT5OZjcYs
My7lZ002PfLKlgDeAvkEYbswbZLyjuubNgv5w/CZc5AaIeFLVdK7ukUzrlz3H8VR
7PFXjNycbRSma3f+f95vJ8Kvvcko0a95B2Q5IIPlKN5g9IwSyF7p8AWFq4aiKrrj
zM+A0wbW6w9qvGhx7bQhtHYryoXgaPyydsSRk52sI23XmOZD5pmlx8KHCxh+Fb0n
fQ6v8KVrTaGdp+cFoeC/+lT0HSlwfuJjjgQhbIk2Zcj6E1fGwa0+uzNTjmgHNlRE
Dvu9eHy5TfSEl7IJmHz9A3Wt5DhQ44Ea5WNbonMg8qz+odSDNHKlFpQ7xxSqd0rf
0K8/FE/4k2sZQ6775i9e7WEuQpMpf2cQYWabLv/S8ZtYqfBV37lr0J7uEV/UTJQ1
8wu6TSCCzN1Ur/NPEXYdp7a8AwjZn3GLn/vICAlaMDmAoPTpX2o5nYMWWrIa/1h4
ExAgN51Uj6duT5KPE6E1Hokzer226BOVwBS7o9Y2kAUtWLU+j56W/nquVG6n9049
wU0c+FfkQzlRI0SGlKYB
=9SBi
-----END PGP SIGNATURE-----

--2DT8m24oj8Onh3Jp--
