Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaGJMwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:52:32 -0400
Received: from sauhun.de ([89.238.76.85]:57572 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbaGJMwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:52:31 -0400
Date: Thu, 10 Jul 2014 14:52:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.16
Message-ID: <20140710125223.GA4910@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here is one buildfix for the i2c subsystem. While here, I decided to add
the header cleanup as well. Please pull.

Thanks,

   Wolfram


The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 098aebc30292c10b31f6aa58bf4fe2c4b26001f6:

  i2c: sun6i-p2wi: Remove duplicate inclusion of module.h (2014-06-27 14:39:36 +0200)

----------------------------------------------------------------
Linus Walleij (1):
      i2c: mux: pca954x: fix dependencies

Sachin Kamat (1):
      i2c: sun6i-p2wi: Remove duplicate inclusion of module.h

 drivers/i2c/busses/i2c-sun6i-p2wi.c | 1 -
 drivers/i2c/muxes/Kconfig           | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvoyHAAoJEBQN5MwUoCm2GZsP/22INYvNK3XtgfWwnjf4osD1
gt/1VweuijCJEEIfxIrl0vkAxxiGpkt6KSYRg9c94ZWCdoLbGSZl+0Be5kMykwUK
ziLKz7y1+kejbAKIifnmv3g1rw+WOP91yC1ZXrEcl8w0aL4KsjSYtpz47XepkXBm
yS1xFwxzUmlTMaNPQ0McSwnZuq/TkYjno7V3vcmtvI1QN8FfP+QcV0m3fTofMNH1
c9TKBPXbM6I+JuUzgaeV4kcZ36vhRswonkDKU5Z866eNUWZPJgMeC8Q4bkqBcItU
bqVDnFW45PKL3QihLSECqNOH/77coUG4lePkjC1YDwBmZYJjqjNK6eN0DOWuV7Ut
1yaR7k9nyRiv4XrnxD0RMV9JJvs7i0h59nEl27CUB0QsHKQhG98tfyhuq/jCHfB8
2XJZYKVLHyxtZDxAWPhvoE9QntZC8wbpUNTAJsNOFL0Al/58fAxZjxFMBp+X2tpX
C3Mi46oTV27f3Ax52jDqAmF+Dny4glNJx8YJKRATdZHti8owVgItEjRLsF6TiCfv
SIoDhSl3gPsQVhun1c8hyKCpdxfY/uPfAFazAv0usOw0355clYMd2xi5h3+vUShf
fPgBqloZznWtqdUZ143EbfwuK6tGkQP+NVthUTfB4F7hxp9FvLvkIdPiW/xRXe19
a6DN/82qZXD895DYl/FC
=is4R
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
