Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3CKVVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:21:17 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:52482 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3CKVVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:21:11 -0400
Date: Mon, 11 Mar 2013 18:20:33 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-03-11
Message-ID: <20130311212033.GA17372@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

I have these two patches for 3.9, these add support for two more devices to
the bluetooth drivers. Please pull. Thanks.

	Gustavo
--
The following changes since commit d786f67e5c587a4de8245336cb64cf4dd06871a7:

  mwl8k: fix band for supported channels (2013-02-11 14:31:36 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-ups=
tream=20

for you to fetch changes up to 94a32d10f47b637ae24b78b1ddc7ef0e8396fda4:

  Bluetooth: Device 0cf3:3008 should map AR 3012 (2013-03-11 18:04:54 -0300)

----------------------------------------------------------------
Josh Boyer (1):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

 drivers/bluetooth/ath3k.c | 4 ++++
 drivers/bluetooth/btusb.c | 2 ++
 2 files changed, 6 insertions(+)



--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRPkqhAAoJEPs3PUX4s20o/A8QAIwMIxVhU2qXsZoaW8yy2VaQ
LY/yDit54L6sRxG20F8bcDxXfkkq0PojiVhqTQVjr/pSFU+q6vpNFMRzxnAY0eGV
Ci2j8/iisy6zwEvcinsBDkqCgBXxcHzEQJ+nYTfIlXcPXa5T0C8TrDs/dqp9bVV6
4fewRewT0vEKmvOrF8NHFDeJuj/THzeMOnYNPiGyjSN/l0z/If2vqR8GPPib/+cu
axBq6dAYRm66nYMX85eoNHih+mcOqMEoZKz6SPfD7lelaAFklZBdS2q/Ad3Qp/4m
kzy4boIoOxOLRtkGNy4OWkmqNepo+bvgg3uZ5cLuXPY05f7cWy6mfi2RzXZlJNHg
OvH/z+u6KSfwHEduNszcH791fU8r8izbHe+otFr8E5/DDv3kttEyWI+gHgWaDS7k
d0i6iHqi2tdmk60ndaVzJ0xX3WEjT8HalkTc2m+AJ3b3RUrug7/8PRk9OQtY2rmR
TSHBnYV25I/mRNT43y2wCufluq7LbPLX6/eD4FbGQvNHKOF5j0rvNhXVC1K1hinh
/ldc5X0TDDidCw6WY7zZ6HkMWYHNxcIZN3Obyek0GosqhHQD8uSVrTO7IV0q0o8i
n8Xkupsui2FMhdnASsZJ/hK7hp2GHmoq766ng6vQYxIqwZ6iSTT7v6TEsLj1WWfu
h0U+gMoDZSNZete4oRwv
=Tz/L
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
