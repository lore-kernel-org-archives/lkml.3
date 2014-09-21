Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaIURtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:49:11 -0400
Received: from sauhun.de ([89.238.76.85]:42470 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaIURtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:49:09 -0400
Date: Sun, 21 Sep 2014 19:49:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices
 addresses
Message-ID: <20140921174902.GA1479@katana>
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <20140920164858.GA2260@katana>
 <541DDA9B.40904@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <541DDA9B.40904@metafoo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >This raises the first question for me: Are the additional addresses
> >configurable? Sadly, I can't find good documentation for the adv7604.
> >Otherwise, if I know I have a adv7604 and know its addresses, this
> >information should go into the driver and not the DT.
> >
>=20
> They are. The current driver hard codes the other addresses, but that's n=
ot
> working when you have multiple adv7604s on the same I2C bus.

How is this configured? I can't imagine every address has its own
setting, but rather some 1-3 pins which select a certain block of
addresses?


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHw+OAAoJEBQN5MwUoCm2t80P/R6TgQftd/uBDonUOAWOWU9D
1dFdChiDFsy5qRyXfsgZIsgxCzMp7MvUyddRGbiA4DgiO3nnA7T/DoVo+3jT4dPC
BWa5PAsFhUl4ZdsKpyWF9kSVH3IlIGdqhKSSVA9wCJnuBHNbl6sd7pE+TfOBI2lg
s+LY8lche9BDDdfuATnBCr+3F/QWj23t1bqR5ML9FWCzn6lLrHPOASEjPYvfriLS
HoTdXzU8pTyVL2yi7pRYbgSxi7a/2iTx5auEyLrFs0bKz3MpUY7XI1gxJbOmdpa8
+aPp1aWmv/cesESKtiPA1bFVIGRWxdClbuXp29xPov6wVDYJ1ly4rZfhHIL8W+cH
MehXy8TelfdefTdtuPxbaTCTWcQfLpznbl9qlPskB9fCfFMfuPG+WWGAFBYPohIj
tnNGQzV2x9HO9S6TNOWC6sfo84smz9l3nRPOmrP6PuC+gBXSiu5nk+Ms0NDPrp3d
XLCA0Y+qApIdswRaBkZSmjzR8sHA8DrLHDD32AvCYzSh+eXneypjqghQ+MugO1LB
aQgbWfrfVvLbCBqnSS4tFHYKBIhOQ9UY/9Npv+qEJ4RSMsyhMvX5nG3wfAl0fuVq
YdbbRwu1XlP6bejfh1gKSzHyx8gf+QdvUUyskykrXVFi2jpEA4GmPyWgv/yDDFRF
FNbN8/3RdJ7tafj0X4aG
=UCC5
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
