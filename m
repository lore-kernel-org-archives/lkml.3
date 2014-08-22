Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaHVTeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:34:37 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43949 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaHVTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:34:35 -0400
Date: Fri, 22 Aug 2014 21:34:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Fixes for v3.17-rc2
Message-ID: <20140822193430.GA31506@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.17-rc2

for you to fetch changes up to d717ea73e36dd5659640fae82605ad85c4117f4d:

  pwm: Fix period and polarity in pwm_get() for non-perfect matches (2014-08-18 10:58:43 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Fixes for v3.17-rc2

Just one bugfix for the PWM lookup table code that would cause a PWM
channel to be set to the wrong period and polarity for non-perfect
matches.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      pwm: Fix period and polarity in pwm_get() for non-perfect matches

 drivers/pwm/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT95tGAAoJEN0jrNd/PrOhqI4QALCvfTmbmxa3aoQH22zSgWDv
VLOOdgUVJdeoasUzDtd6KzzPXD2A0X6BgFvDu8BUYaCjE9TgqaU444PVYTOhryog
ZhibIw2MhD2bDhh+dsx6XXD0to1kl75jxjkyirOik5dVRADO8KGs+Tum8wf5ysDq
Yco42tFVhN4zmfmkh60znhQN575Sw9cBGYLVqprxErE6+sWCFZUV0jelPOiD0iyE
ZLZJUM7EZsIDDTGI5p4Jvi4tcB/TlirvT7xw/fcVQcP+7T5yJS7kbjPLNllcPkwi
8Nve8pCgrgkdtOaKBBMgb5/jukobrobwaMAGh/wZ+nTA3BkHrd5Q9uZA/dWIk1jh
3mulcM5xezNZG4Z6CCkYXJI5e6xM7PVuF1to7VBlvnHNRD2KSbI6EM1J2qSmfzrb
OzFRjLD+CSNyJ+Q3u6aLRRhdLYTLhsODFLESdLpVPI5YbzqAUbemYj6z3GupkTNN
dRDJFFcnlvzCLSviGw3J4WcTp8EOd4jwlomBSd0ggmlmVuTMWaN4b6QVFoM5BXuB
Fi1oK0Gie34pRQfyQitp2BJHBttFXZ5C4ylxBQruPvx0SrYXbE7YEdIGyUwL1fuW
2StBs4MZxdjlWCSF3MmnNhIX4EjbhNhGEgwWOHSXuZR25Mj/mGAdcOgOFbj+7Rtr
Zv4dSLJh+na2yTH6YEwl
=pTCz
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
