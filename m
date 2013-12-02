Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3LBT2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:28:23 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40363 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3LBT2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:28:18 -0500
Date: Mon, 2 Dec 2013 20:28:13 +0100
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANN v2] New central Linux backports tree for development
Message-ID: <20131202192813.GB15791@cerro.do-not-panic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[ first e-mail made a typo on a mailing list ]

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

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSnN9NAAoJELt3oFG5aZ5Lp2UQAI671er0Pwvem09LtS6JTBap
W5v4dPW3UsO2jMj8y0EjcUAif4/ugwqHs2lCVZRUqhkth10ZuzQyXnPifgsGmmjw
sXbA/ahaakr+upDErRJp/HCUwvuChOmdmjK0cEWZlIC5ipfR3y11UUPtAKYH/wzT
6Q5HDnVItkmus7Hc9Chugyocbp+QD43qiLnyK8OaBkoYRVjfasKNRFRboHcDGyzl
ZxBAsmXqrbIFSh8zGSwh4WbxxncxBwshJ0AuCfjx7BrOZ31nJwsT/0WLWLtTpBrh
00/TvxU88fJOKfHq9J1S6mAkztmKnTJEoripALUHhUksSBCP9sBcf2MBZXw4hsws
bYHCa2si6oNC5RE4J9MQtCL+RcRBWBbKdZ5lYV/tbZm0+bqYaHC/9MFeHmIokUys
kTtNB1d+T/OT5qsOyguhak9oN5XIW0UAqphJCzv1TWK7CdeSMkrNb0QTu79AUaJH
Pl+0lkgsPsWa9/GY6rjEmbM7gnq/1aRaFGyemBOQ0zrLJLBFmARuRKOJrSkFSXEm
f6+8Gz/ki0F+KCh5xaFnAbOi6R0TsE9wMkCWN7tLbPuPLqFahN10C6xRIOjWkI8l
yoVSIzUEYg70d3ZhnulO1M2g/DC7pPHEVNgfWRqdbc2y043AJZH8INsh+A7itkJF
F1vrL8+K6GXQThzXngj+
=xiBj
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
