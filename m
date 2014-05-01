Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaEALUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:20:13 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53453 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaEALUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:20:10 -0400
Date: Thu, 1 May 2014 04:20:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.15-rc4
Message-ID: <20140501112003.GA23970@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.15-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to c0940e95f7a78be0525c8d31df0b1f71e149e57e:

  Revert "hwmon: (coretemp) Refine TjMax detection" (2014-05-01 04:07:52 -0700)

----------------------------------------------------------------
Fix Tjmax detection in coretemp driver

----------------------------------------------------------------
Guenter Roeck (1):
      Revert "hwmon: (coretemp) Refine TjMax detection"

 drivers/hwmon/coretemp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYi3jAAoJEMsfJm/On5mBJKUQAJVE3egaF9XFJldX7dDN1XSy
k++r6EQFxncaTpaVUAx64fl7o7bDzZ0EYSji3QdsvBvG5ypKbcYHjJMsanIs6i4W
s9H8sYIhICgC/fII5TO+NrDFjFCuEaB6MA5K/7mM+HuH/u3XjXVmyOg3FTRe0j0T
nt1LpSQahpAgjssR/hmANLA4GbFP9vlCOjDYHWXVHlbayTcYOS2uHZZ5dKGtrDke
NyahT95ONLqpjDeH/NK5380dHG6gITDQw5zir8oEchIZD7hANiRPLrGW8ZHcsb4x
2c8mSlidjexoDqHJUwozBxdOzSO75zTiH0azek9hwLAFM3LnHDDeuSQN2Qi5wONs
2ys8XHyLxfKEQZLic+JrP1I615qk5evBhQswp3HTthLPsrQM20U4ARaKktuFNxs9
pN1vBPfK3D6Ka/vv4umFygFY+LOmk/eFeO5+eHnf8LR/qdUAEP264FGSf3JnUyPJ
wfSwXjQubPJQC9s3f8ZWbYVnA2l227U6ykjTvx2ApgagaQEmb/9hNsSXu3Sotrb0
jpsN2xStQ7ldsthtX48yeijqA768+KbbZAD1fAbwCXYS2Idlg5lQIfpR9XEwjiwB
JVb/Ki8ko7ib0JeBGAooXQ4jgDg9cMJbg5inI/X0UhMvGlYF5YPbnU5Nq6Sh4E/b
qjBF9HCBLYowjtu8LQdT
=ruQG
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
