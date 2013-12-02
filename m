Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3LBT0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:26:48 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64273 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3LBT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:26:08 -0500
Date: Mon, 2 Dec 2013 20:26:03 +0100
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.or
Cc: linux-kernel@vger.kernel.org
Subject: [ANN] New central Linux backports tree for development
Message-ID: <20131202192603.GA15791@cerro.do-not-panic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

First, thanks *tons* to Hauke for taking over the tree maintenance
while I was shackled. I'm back now though and ready to help
out again, so keep 'em patches 'comin.

It was convenient to switch maintenance between me and Hauke but
it was an *inconvenience* to tell developers about a different repo
switch during development, as such we now have a central repository
which you should use and update your trees *one last time*:

git://git.kernel.org/pub/scm/linux/kernel/git/backports/backports.git

Please use this moving forward, if we ever need to switch who is
maintaining the trees this should hopefully be fully transparent to
development.

  Luis

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSnN7LAAoJELt3oFG5aZ5Lb/oP/2trpgwJ7o5z61KdVC84uR9X
XWr39Oqs7Xew36eLhKF140f2q6xkr12dAcsvVYKAX6UYpkoKNOrW9TfmnqnLUAE+
Nvv/euVZrI9Q8pbq5ENFc4w5EstDBJH6EwSAxjV9onH0JLKGX/WjisCopB/YxLtQ
j+O5X44G6xV/csIbYoy1yohmUsQKrSeMog+gCxEHujyaWVAQoxgXTucoUVUzr8tx
H7rrlEoqq/AeZ6WfnTdIrSArdmPNksOqg6FIGiXB8X3bEdi65RWcXPRu3FszwQwC
y/3M6HIWgQNJwZCk/FWxV+dQtHXBgSC+B0iQY98/1/uE+nTD2gKOSflYGD8KYTsy
+Un4V3BKg17rrJ65dRoATvzXOwCSf63o++EDTeH9luvJKFWT5cFlWh0+yBAHO0KJ
sXFthwOfpKwFbMU/L4OCiuCURbHBMd1zVwzumzEhJ0zvOItfnglguqONE9Dqj9X/
OKyA+e2I2jIqDYSetllcOUCbJWUKiL8ROsaN11bg+cmL93hVdAc5zKWi4X1aYVQ3
AwNe3QsI45jU1QfiMID7iNGp45vR+Mxie8frfibyea5aUKGyaBHanNAaPDzl1H5v
T9bOzQnuARSo40ThWf37dRzaAfnneOS5hnKAcnXTD/t+diIopwYLKs9QY6kHeTM2
OOT0hZgSDD2gSrrnN0Ji
=gbm0
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
