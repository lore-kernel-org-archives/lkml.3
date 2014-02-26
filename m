Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBZPJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:09:00 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57682 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaBZPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:08:52 -0500
Date: Wed, 26 Feb 2014 16:08:49 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Fixes for v3.14-rc5
Message-ID: <20140226150847.GH29779@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pfTAc8Cvt8L6I27a"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pfTAc8Cvt8L6I27a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.14-rc5

for you to fetch changes up to 0b7d25c347900e2550398e29e25caf0fefe3cab2:

  pwm: lp3943: Fix potential memory leak during request (2014-02-26 15:45:12 +0100)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Fixes for v3.14-rc5

Just a single trivial patch to plug a memory leak in an error path.

----------------------------------------------------------------
Christian Engelmayer (1):
      pwm: lp3943: Fix potential memory leak during request

 drivers/pwm/pwm-lp3943.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--pfTAc8Cvt8L6I27a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDgN/AAoJEN0jrNd/PrOh1AkP/2sQNeKi73Rm2tkPny0aPwOR
+I5hsOcp639xBZiezW4t19DKQY4dbme4vgROTIXV7quDwPsYBQhB8+sZuJoH3f+O
msJI412AHvcW6AhPh+bXvnYaR7geJNHpp5Rd4Zz16w66TCbG3D+8OW1nOs7gOnle
z+EfLCVDyuFGckSEDwTktNpZ0DFYwELdQSofGzRjdG8UNGkdAfehUYxZ07Kkmb4T
cq8Dpus2kvJHSvl+iljkQek5U2A+UDM8ycz8UUiD3YAq5xIs0J1mdvHl3OJ1mA9s
Aku6+Kr7yJIcnZbVdn8PIb41CDIK0910K8+vxHCN4txR8z/yEO/E4EPGqW4jpt1+
XaqUJ+GusAtk2zM88klfEm2yAr3QZT1x3sgdgGPFtTmS9LsRB8gy0nO8vZB+DV1n
3zXFEIYjJA8azYXV+aVUIYXQZSgaFANUF+fvzweiAm4snEOlslVI1QeA3X6Z3luo
YC8YrlxSe7M/d+GxVMEvtAGAD4BTBr9V/cT0CosvzwoZiBqkAwoVfoYpHL2vx783
Jie49SS5j6syO+g/sZidu6BzZhOESjMs4L5xKnExomzr2/0S1YWjMlvJzB90/VKC
/zrDR6Mq+5sHOWQ7H+2wE4vyUhXNCMv/EqmOX3rWNVRjFmdTfIgnRT3qvvX/hiV2
68P2fI37kl1P1KwyED3E
=nN45
-----END PGP SIGNATURE-----

--pfTAc8Cvt8L6I27a--
