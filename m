Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbaC0RoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:44:03 -0400
Received: from sauhun.de ([89.238.76.85]:49570 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbaC0Rn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:43:57 -0400
Date: Thu, 27 Mar 2014 18:43:55 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.14
Message-ID: <20140327174349.GA11698@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

the build fix from my last request unveiled another build problem which
is fixed with this patch. Please pull.

Thanks,

   Wolfram


The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 5f12c5eca6e6b7aeb4b2028d579f614b4fe7a81f:

  i2c: cpm: Fix build by adding of_address.h and of_irq.h (2014-03-24 14:54:21 +0100)

----------------------------------------------------------------
Scott Wood (1):
      i2c: cpm: Fix build by adding of_address.h and of_irq.h

 drivers/i2c/busses/i2c-cpm.c | 2 ++
 1 file changed, 2 insertions(+)

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTNGNVAAoJEBQN5MwUoCm2OjEP/3W4bj4Ab+Uxe8knRgqVqujN
ybK+PcnXjGtPQa2NYbg8Ei5hCMW8J7DXREJ2wJJkQUdrPDI84UkI7z1uscXQEVc+
WvjfRhxwbpq3JnAnklcRsWX8mRc/Otkwr1vnrG2tbtytoRUwJJC9hF3XLJsfwMzf
VvBJ1pLsFaFhAyRuBG7SA238rXTpEhyD38JNGiMzjvFfqgZQvf8g5bjO/iktmFd1
tH6oQmdvO1A1CnvIkGggUNSiRZ1FWKwP3hbZ960S83sjT5t+MbyhCdE9G9zOfzo5
oYdf6AgJBCZtg4qGY1LS8Wl1xlV3cuxUzC0A1LQ+aZmBdDnME8oYWKlaPhgMlwEl
w9wynJjEqDPJEkJtSGA66xXEDspvpaNPM2j/l+/ECNCe840ot75g2qD7NR3ZzUVR
yGyfgV2CuRVqHoj43P5Udd0cZY1tLSde5Vcmfcxw/TwMp8UxjR3xOodvPiKC0Bky
GDLBjYXPOZMi2xhknC8bqXGvDm9rktgKrHmNHZVNpfRPVObUu1CTmgsozLvrAduh
DSOTVWkqF0LAPis8+UyXu39YIraoOiHkYVl1xJ6veWdHtshQsjhC9YH6IV+wHzmN
yP35xzLgpte+rrf4nkduWsSg12rzK21LbmTy7agBZLPMgJe62+iLYtlX+pj8yGHq
1wH6GtEXehz4FJaJ0aBr
=NJs2
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
