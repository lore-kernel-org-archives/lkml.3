Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaLFI0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 03:26:38 -0500
Received: from sauhun.de ([89.238.76.85]:48916 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaLFI0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 03:26:37 -0500
Date: Sat, 6 Dec 2014 09:26:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.18
Message-ID: <20141206082629.GA2311@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here are two more driver bugfixes for I2C which would be good to have in
3.18. This branch is based on your tree from two days ago to make sure
the fixes I sent previously were already included.

Please pull and thanks,

   Wolfram


The following changes since commit 7cc78f8fa02c2485104b86434acbc1538a3bd807:

  context_tracking: Restore previous state in schedule_user (2014-12-03 20:55:58 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 681d15a0f527af7ab3a783e1037de86fbcb136ac:

  i2c: cadence: Set the hardware time-out register to maximum value (2014-12-04 19:25:41 +0100)

----------------------------------------------------------------
Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Vishnu Motghare (1):
      i2c: cadence: Set the hardware time-out register to maximum value

 drivers/i2c/busses/i2c-cadence.c | 11 +++++++++++
 drivers/i2c/busses/i2c-davinci.c |  8 +++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgr21AAoJEBQN5MwUoCm269UP/1MpLPr0TFk0PO1J+Ng6JqTP
8CCnBQDMV5tGWOh0moQy1qUWc1nu4d1DM2F1jvyoqMKZZdc2E7hqe1IRMB28ybge
1LgraiSXYTazWCQmvlVklQsGycRv19cv+7lw5PumN+OW6QBLM4japbhmVEHq/9QS
SCmttNNyzdWyRBn8FgCUZdBshqpsnnIhLB7lOjcuZXdF04cdEm0ZtkU+fWGvaAt1
doUtOVvw1VeOrbU7guFRkctmlI87F0MFqnWV0qW5brfyycmLFuyjY3iLR+fEuV92
bzls5UFXC8ZZkVou1hU/4lc1G8IPxAC8Q6vrBkcq97PaooJapE5v+U1R5wJjE/XS
MPijIfeFL8PpIOk3tnuy2GSX+4yaK3iQnRJBz9VwyF1fiRwUApGoLcRuOaMQ7Jg6
EryM6teh2f7wli8Lrhfv+e0pkG5vn/YrLBq8efkv0sUFalJuXLEbQC3kNgOxUC91
5wP7QrXmEVuGHQBzP7RAl+ODRAWyeVVPPEJm8ZTd6vt1i9EdZO/M4yhLt71B2JT3
kaMI7KCpK11J/713TSxJE+CjlML7NGpZKnwAy0x0v+5Mr+SrtBdn/ssVlD83rSUf
9OPnB62i+dONOYol1g/AVHb5lQGAYJQyklYIYRg8bMrXYOPPDHuXcTp90INotQZj
BKif8Mk9TDVgd/XnsNRf
=VSxG
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
