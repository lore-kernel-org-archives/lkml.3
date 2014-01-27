Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaA0Oz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:55:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34639 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaA0Oz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:55:28 -0500
Date: Mon, 27 Jan 2014 09:55:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (swiotlb) stable/for-linus-3.14-rc0-tag
Message-ID: <20140127145521.GA20557@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git stable/for-linus-3.14-rc0-tag

which has two tiny fixes. An update to the documentation and a fix so
that we won't get DoS-ed with tons of printks.

Thank you!


Documentation/kernel-parameters.txt | 6 +++++-
 lib/swiotlb.c                       | 3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

Jiri Kosina (1):
      swiotlb: update format

Konrad Rzeszutek Wilk (1):
      swiotlb: Don't DoS us with 'swiotlb buffer is full' (v2)


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJS5nNUAAoJEFjIrFwIi8fJfagH/1X3Y+uDkm8Fq0JbRwj7QG7P
i30wBE0K1gnWZSypOCn8RHJ/PLFbfA5ovkHN9lS3WLe7XMnVrA3HbmnL/5U9RE0j
jAxrI8lxDais+ZtHyeurXfl6w2DoC9uUmDtYiZiTGdEis1QBqWiiJAqoTFobVqdL
o6l6IOBO4H/zMx80dIzd7vTlt7k/Ho+KpYaApl3nU6zNradkWivcDPuYt6gFmw9f
F1O49X0b5z8qwjohwpIvNLSk3JTSCmYYW5Tu9naSsX5cvBN7OiY+6MRFCryH9kLz
D9Dj88cdsX6JIfrqFITUZlLfwdDVJoD1/8unaxf8WyZpMffsJlmWZuWR6qeRw9I=
=BTwB
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
