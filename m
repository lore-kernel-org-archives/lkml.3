Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3FIRyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:54:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54854 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3FIRyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:54:03 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 9 Jun 2013 10:54:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.10-rc6
Message-ID: <20130609175451.GA13332@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Linus,

Please pull hwmon fixes for Linux 3.10-rc6 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

This is not a critical patch, but one we'll want to have applied to -stable,
since the misdetection especially of LM84 has been causing trouble for quite
some time. I'll leave it up to you to decide if you want to pull or not.
If not, no problem, I'll resubmit during the next commit window.

Thanks,
Guenter
------

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 591bfcfc334a003ba31c0deff03b22e73349939b:

  hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617 (2013-06-07 12:29:31 -0700)

----------------------------------------------------------------
Improve chip detection in ADM1021 driver to avoid misdetections

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617

 drivers/hwmon/adm1021.c |   58 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRtMFrAAoJEMsfJm/On5mBHBgP/R/FHADe+gu4zCG1iKVjSyrj
3IMt7Z0cINm55LfgHu+Au8yF7AcKlgIdEDuRFGO54+j8IYJq2NkWccXFsQfJ7DUs
JlpKjhN+29RGGGamG0z9hxYqcAyk3gTLIrz0amnBL84D21qpfkPKy/TE8d9mOjUQ
clzemgUvFlP8JsIW7ubDhzwF1LOZwmR/Xp/e0jKv2O/1+6m3AHMg9s4cHxKfltLW
72le5QyORbhSOg30mfmswWdas/Uon9TnzVHUBoWf0aoSoFufXgWvVZpoLFE6QHdx
ehGmxk0iChPqSej7yLLsFutC6K3TocYTf0GHv+87z1e8afN/h0bPfTKfTHUhGXdP
5oEOFeHNuLWJ4X+SeWqhjtVNSEpAMkubkNimH4onc2qpupa2SBLkkseDBfqAux1s
CZKZGhKHyMYm90cIVWsW+hqUKtKOfWk/3r5oz3K+fUcB03o7iXyWGxUXyRrJk8xF
mlCnOWwhx2sFs8cxxgoclEyVOJTT9qCnVcQ1iUfSCvaeNss++eyeXh8REBOFF9lt
nYujMnXCi9cndxAwHe4JGBUIwXksTKQq/0vRRM1+QL+9H/6W0JJqCM6y0jz+XsE2
i3nvM+53sKpSpbClmFjdsudXvgBs5G5mI1gg/be/UOiUH2l2rtEe3EAtg7a3tUN4
gg2MWG3rEA6p3G+Whp4n
=9d+d
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
