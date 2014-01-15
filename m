Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaAOM0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:26:55 -0500
Received: from sauhun.de ([89.238.76.85]:52202 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaAOM0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:26:53 -0500
Date: Wed, 15 Jan 2014 13:26:49 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.13
Message-ID: <20140115122635.GA4004@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

please pull this bugfix for the i2c subsystem for 3.13.

Thanks,

   Wolfram


The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 2fac2b891f287691c27ee8d2eeecf39571b27fea:

  i2c: Re-instate body of i2c_parent_is_i2c_adapter() (2014-01-14 17:11:13 +0100)

----------------------------------------------------------------
Stephen Warren (1):
      i2c: Re-instate body of i2c_parent_is_i2c_adapter()

 include/linux/i2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS1n57AAoJEBQN5MwUoCm2xGgP/jih9lYi1LQSB7WStvaLH3bB
jxnNRCu9o9o3j6iNUkow9BfVbm9qwQiFqp+mxAfimEP1kI+fAi5tsA/BnU7FrW+T
3FRRhaIcYdBj4MaGwc4xiDuni2xb/bSiTVGxLw8jIcCJZeADTrbBqPjZJTFVSHG2
HROZqIr+RUbaO8hvKc4d43mnH+nza9P+nHcH1FThMt0S39xuiv61kaKpq19TyP8D
PpY3Xsai0eWmsJo+5+1TV9XisnOm87NNgdBF+O7DXtk1q5khVDIprKvfub5hjYkG
F1kQciKcH1F8C8pyBkUink2Upx9vsEE6XmPooCXqpfoJKBxSci2+6jNmHZOkvdmQ
YEfr0jy/Zfgmbo3xFAWPHklczULGBOkGNeh5Pp4ehI17cFQCatRhPXl9UIe8Ryfp
D327eDB/d/7Ob5xaGNdyF8g+gJKOP6NL0fg1XvCznw8m6z6a6L4vEbnaZ7WnIsLo
Adw8fmkCLtZasjCb5JJ1qPKPzvfv+tx/J1u29jbi+uxFjBxKtcQlQcSMKPSeth8u
P6mBiQbAxy/h0bfQadit+ODFiBxz2SS82gB0HczEfpyXBD10yDwql4TJQa3PwYFp
Wv6/WM+rvNfvBJb/62+UbAOrKljTckk6nyVcBFfUFvAKUtUNs5+DTNDrGLaxn/qN
/y9NSO4nGo6j5TjEwIMU
=RbvI
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
