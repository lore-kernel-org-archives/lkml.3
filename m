Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992470AbaEQHTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 03:19:43 -0400
Received: from sauhun.de ([89.238.76.85]:37158 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbaEQHTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 03:19:42 -0400
Date: Sat, 17 May 2014 09:19:38 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.15
Message-ID: <20140517071932.GA3087@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here are some I2C bugfixes for 3.15. Typical stuff, I'd say. Please
pull.

Thanks,

   Wolfram


The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to d7653964c590ba846aa11a8f6edf409773cbc492:

  i2c: rcar: bail out on zero length transfers (2014-05-14 18:59:57 +0200)

----------------------------------------------------------------
Andy Gross (1):
      i2c: qup: Fix pm_runtime_get_sync usage

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Ulf Hansson (1):
      i2c: nomadik: Don't use IS_ERR for devm_ioremap

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers

 drivers/i2c/busses/i2c-designware-core.c | 3 +++
 drivers/i2c/busses/i2c-nomadik.c         | 2 +-
 drivers/i2c/busses/i2c-qup.c             | 2 +-
 drivers/i2c/busses/i2c-rcar.c            | 9 ++++++++-
 drivers/i2c/busses/i2c-s3c2410.c         | 2 +-
 5 files changed, 14 insertions(+), 4 deletions(-)

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTdw2EAAoJEBQN5MwUoCm2//IP/2DFFyi8tdYxj0CqJgFsaGrH
E4ub9py4HcP/ibgtpKTv8LETSf5umpd6sF2ZA77s/TVKGFG8ITsK6Dt9IS/pDQoW
hUnw77USQVfpn8kx0DW4WoVExHrbnv6yLoakZzrEy0yINLxQ0DLQgiXpuvF1IEnc
WIgdgVtbCwQXRX0BhBebFUx0SoQ2xYnNWcgA3M7B1hf8NwFK0X6lpWR1s7/ReXK5
G5iGM+a3Aavoo0FzsHHl/VIrNpuIdEpFPv8Xw9th3Iw4wcDURCqK92+sVlTp5phC
fsb6bf5Nv7Kn2fj7kLFEDiipl2tufzKl40edJY7ywADSThXHpWfZKujHqOjkc0tf
/wGopO3thCRNchwiRmKUK9/MP36rsAymesfC3YQG11V+RXron/Hlrn9f/Dgu+Dk+
5jjo6EWqeu0BznM4r+osS558MIKbWjvd+P8xYVcpAhvkTbpwQWEqru8eSVRTFz/W
1bpKKBFC6LNlJm7pVSGabs8iVWYFFE04XzRAwDZxPqn8IESlktiZiYSCROZuSkET
Dofof0LmT6qH1ATOlMkHe1ezskWE/Hp9jOYqpgp6OGCsxRzSZE4bEWWT3bLd4gSI
9Ak3xg3LnKlv0E0UJ7SD/+aBfnXdmDwJnEpFVzU+yauIby1kIsq5vd4AC1+Z/QuJ
3gL7fMwHS1w2Ij+C58kC
=J+oH
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
