Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaAWSQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:16:11 -0500
Received: from sauhun.de ([89.238.76.85]:58602 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298AbaAWSPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:15:46 -0500
Date: Thu, 23 Jan 2014 19:15:38 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laszlo Papp <lpapp@kde.org>
Cc: Curt Brune <curt@cumulusnetworks.com>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>, wolfram@the-dreams.de,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Add at24 based EEPROMs to the eeprom_dev hardware
 class
Message-ID: <20140123181537.GA3756@katana>
References: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
 <20140123172534.GA2665@katana>
 <CAOMwXhPqnSNWtPMo7Qrr-O3qAqtjju7au7Mudckp7kN50yQW3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <CAOMwXhPqnSNWtPMo7Qrr-O3qAqtjju7au7Mudckp7kN50yQW3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Well, it is not the Copyrights section, or you are saying the same
> people should go to MODULE_AUTHOR as in the Copyrights section, even
> if it is potentially several names? I thought this would be the name
> of the person who put the file together even if from existing sources.

You may be right that the two can be viewed differently. Nonetheless,
adding 10 lines to an existing driver already upstream does not count
for both.

> >> PS.: Fixing the broken i2c mailing list typo, and updating Wolfram's
> >> address from the broken (obsolete?) version.
> >
> > It came through to the i2c list? What was wrong?
>=20
> Yes, it did, _after_ fixing the typo in the mailing list address.
> Check the original mailing list address typed for details.

I did. That's why I asked :) Plus, since I got the original mail, it
must have come via i2c-list since my pengutronix address was in deed
wrong.


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4VxJAAoJEBQN5MwUoCm2L/UQAKyTIauMbVAIrX0eV/S+8cQE
vPcqM1yprtczIO9ggb4Wr+tIvvV2dZbGzu19O5/65RHWGeQL4kAKq1d1i1tf32yS
7YuEkALUKIO6hgHs7GXV0FeC/q9wYuzlq0DbpEZYqrqq5ok8Q4A1JHkBI6FUz+kx
YpspV7Wr3kTjQRwZ7igxhucROSD7lEohcUQJKuC6EBl/MluuvmFDtv8quuwLBn/M
rTv+QNKkE0CkdApUdqHsnaAX+y/i3JPz4rEyABR9Q15smOF2dtX0W6ipaCUNiEeg
VeJzChwJWXNKMz6CXIj8xhr0S/bxpArxc2YH8m8e8kabhJdqQxLpddbXc7SBbwr2
vad92J9jHfcR+4pqgoTOaP8kNdryGKYweQDb/U6PZIGol5FnCF3/DvDmAclHpywB
x51NvigSMwG5rAd95wl3NLdWaCVLWlR1sNoUeFTN3eIYUSpnpVAMevCMEgpn7NDn
GbNsPfk+mlHhL7i+Lj3MIXHxsk82IwUjnaVpnMoi34TB059CpK0rcm4LRTB1oaTr
yVTQaBKSRa9pY8rri8a3M9yWDyj65T5Nbsob3ltZIyYhMisd4wGHWRjwJQ1wqIpw
QjhfVQx5mAPQBpoOAapLOjuq3AA4xuCJ0aQGXFGuEoPvFXx3mxL2SJtkvcLpqHad
602JEqx+eXwOaXdaul7r
=H8WQ
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
