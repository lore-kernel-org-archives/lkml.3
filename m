Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaLCUWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:22:39 -0500
Received: from sauhun.de ([89.238.76.85]:53903 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLCUWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:22:38 -0500
Date: Wed, 3 Dec 2014 21:22:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.18
Message-ID: <20141203202230.GA14053@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

i2c has a few driver bugfixes for 3.18. Please pull.

Thanks,

   Wolfram


The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to ccfc866356674cb3a61829d239c685af6e85f197:

  i2c: omap: fix i207 errata handling (2014-11-22 22:07:40 +0100)

----------------------------------------------------------------
Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Andrew Jackson (1):
      i2c: designware: prevent early stop on TX FIFO empty

 drivers/i2c/busses/i2c-designware-core.c |  2 +-
 drivers/i2c/busses/i2c-omap.c            | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUf3EGAAoJEBQN5MwUoCm2xH8QAJBG7YSmMv74DOv1GuIJaQP6
KMWMYiUHa4uaOJ5sToNTN+Fz8Xz3yEwuznWrJUeNcQe0vZjuHFQyZg6ouOZPkYz/
cnHIjDXJHL92DW9xshCm6cvc7EMHa4HwKxfMmeoi371oCZbV3+x4hXVc2KGgdsU3
RHvSplYD+usEumOQSQJdex6sF1YxtHmWLqT8x2zhF8R4ViIjRTl6kzttGEBkL0L6
xsALQOejRU/Rougk3Spe7f6ISRnn4MqnTJ/VbqXHwl688qHX43C66Yql8+kcNziY
8ep0OkG79ImjWC4TO8G58cnTKkzm7wjb7Up/y/jWT45AAgi7UUoqQWVdRoNMbs/z
nqy/FgTiutPxgh7i8dGDPeDrG0TuNB0sy7qfJqmZRQB6+Qar81ysRyuAAKw8pYYQ
CEFWlws/MOrPoKJeC69R4qQVVoHSBJtMlvuLHfKoTaaQTB4EfYDWCxqskQIrKQxw
dOPoKf/FjNrnilAT5t83l2YLeZRWNIaeCCQH5fuvcS+DCojPk1XUCUg7nTsqyVxf
L39+ndM5kbtYWiJb/XeeJnhd8IcbDCBCC0j4zoyGEY4Zh0Z760iiyByAdUw6X+7C
C9V2uS367QV0hRGT77/KqIIVTM9zdQR/3EHfXoCa8YL1dKzo9OeHhSBiPsVAycZu
8/EdPIVMAeVP5+3HIq7h
=kICW
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
