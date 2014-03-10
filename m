Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaCJPQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:16:54 -0400
Received: from sauhun.de ([89.238.76.85]:56196 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbaCJPQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:16:51 -0400
Date: Mon, 10 Mar 2014 16:16:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: designware-pci: add 10-bit addressing mode
 functionality for BYT I2C
Message-ID: <20140310151648.GB11592@katana>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-2-git-send-email-chiau.ee.chew@intel.com>
 <20140309085357.GA4695@katana>
 <604BF5F4C5D71041942BC7E84ED659EA0155D56E@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <604BF5F4C5D71041942BC7E84ED659EA0155D56E@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > > +#define DW_DEFAULT_FUNCTIONALITY (I2C_FUNC_I2C |
> > 	\
> > > +					I2C_FUNC_SMBUS_BYTE |
> > 	\
> > > +					I2C_FUNC_SMBUS_BYTE_DATA |
> > 	\
> > > +					I2C_FUNC_SMBUS_WORD_DATA |
> > 	\
> > > +					I2C_FUNC_SMBUS_I2C_BLOCK)
> >=20
> > Can't we have I2C_FUNC_SMBUS_EMUL here? (Need checking with
> > I2C_SMBUS_QUICK)
>=20
> Per my understanding, this I2C host is not able to support I2C_SMBUS_QUIC=
K.

Ok. Thanks for checking, will apply this patch.


--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHddgAAoJEBQN5MwUoCm2sncP/3GZzgzWyc4WnCNkhGy22CV/
TxqT99DZaV8zpHXjjOCjqC/6RNWot+erxoAPvIoKe15rJzbMVl397dSbT2/evVvv
rG2ZD7fx/73opRY4nz1Q0dYDbSSY7DOy3Avcds8jbFIGMqIue+WlkRRoDH+hn1wY
fze9XiGnIucK68mCdJKibRsu9wYi8q0x9gJOtTPso5pSNWXMiyUM1GA0YyjdvDO3
pKiA/Goxrpc+nY+pxlUQEITJYrXCUTRTt8Atgv45RVdErw1S3yu/E1y7DAGCj/Xw
fBf1RHUd5ikeyvtISk8eXIHJCsfqWsJEXHR4RJkJTHMCqdD4QUxglRd0OnvkOakH
qOk3R+WRtSOEQwGyKZXlGgVjOAW4BvtGZsLxRR46Nhqanh5x2/uVXaaH7346m8qJ
CmHdpvq8EuHnsb2pzwx1G7bthRk4KsEWobwLdPC1a1kq/mGIZfSXh1yMRH3U+U5L
z8+Nzoq41q7Q9o5A+RsuVe2uX0fW2zTz1vDjinZKu1D1wc+eaaEFUAkLYR3Z8DPj
gY9BBnMFQtPqUNhZboMY5JgRpmTB/dginhKLizLVmAGVTGVE04VFZF29c7u7UPpb
bYEqXMkQNbRBYx5eJLAEWJmOLOhIXa1XlWowJbkm2piRkImeFjHMBrQ53IzeDsbC
YEqOpLWQvhtrwEpPcP1Q
=v6m7
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
