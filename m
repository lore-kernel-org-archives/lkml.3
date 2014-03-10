Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaCJPPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:15:34 -0400
Received: from sauhun.de ([89.238.76.85]:56184 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaCJPPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:15:30 -0400
Date: Mon, 10 Mar 2014 16:15:24 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA
 hold time value
Message-ID: <20140310151524.GA11592@katana>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
 <20140309090339.GB4695@katana>
 <604BF5F4C5D71041942BC7E84ED659EA0155D5C4@PGSMSX103.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <604BF5F4C5D71041942BC7E84ED659EA0155D5C4@PGSMSX103.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 11:34:49AM +0000, Chew, Chiau Ee wrote:
>=20
>=20
> > -----Original Message-----
> > From: Wolfram Sang [mailto:wsa@the-dreams.de]
> > Sent: Sunday, March 09, 2014 5:04 PM
> > To: Chew, Chiau Ee
> > Cc: Mika Westerberg; linux-i2c@vger.kernel.org; linux-kernel@vger.kerne=
l.org
> > Subject: Re: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and =
SDA
> > hold time value
> >=20
> > On Fri, Mar 07, 2014 at 10:12:51PM +0800, Chew Chiau Ee wrote:
> > > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > >
> > > On Intel BayTrail, there was case whereby the resulting fast mode bus
> > > speed becomes slower (~20% slower compared to expected speed) if using
> > > the HCNT/LCNT calculated in the core layer. Thus, this patch is added
> > > to allow pci glue layer to pass in optimal HCNT/LCNT/SDA hold time
> > > values to core layer since the core layer supports cofigurable
> > > HCNT/LCNT/SDA hold time values now.
> > >
> > > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> >=20
> > Can you make use of those instead?
> >=20
> >         u32                     sda_falling_time;
> >         u32                     scl_falling_time;
> >=20
> > This is more consistent with using sda_hold_time and lets them have a c=
ommon
> > (and more readable) unit.
>=20
> Would like to clarify on your statement above. So you are suggesting to c=
hange the following=20
> variable name in the code? As in:

Nope. But I had a look and it doesn't make sense to use the above. So,
just forget it :) Will send a second review.


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHdcMAAoJEBQN5MwUoCm2qqcP/2Dn2J/aWSh9xwvNF5+kKw4t
Sz7sNOp8V09BGzGD5VpA2VRrqB2UsMAhEZtASwLpFXruvZ4TSu9OGSLaeeEwgQnj
nNLxx7twBEdFMfizd1va6TfJcXGbAIdBXVIX0HF64c0C7ohoqhxJ7oIKnz+sYtFf
Y6tISLQNP+by7OZw++Q7Z0Xm4COPJlPvcYPvG83aKsZP7SbAh0Qi2Z5AFWyDDLgs
Z8hQZVyzGBa46d/D/yB5GDIPlw4KrRK+/CU1rm9y7F+N78Zkcd3TPqsBlkdcBAkG
w4bqZTFdiPgDBVMa5gD2V3fmPvkIPxwkn7pKWzUus3qc8WUG2UBmbLC0vPpTxk9j
cV1yw0yrFD3us25XeDNzW4RMaUbic+Cx2f/odOjYBcjyxqvHM1mqfKZ6UrfoEpDr
pZCrE/VOAVoG7QOZPChmMM6O562n0HeBUDXdT99mBpMmcVTxsM8TYXq0zXia5dXE
+x4xxatdVxBBpJp+8eXwIGDn7px1CyhyoxoJ6OFiBSEt66eEjDbuPea1+DhFIBR1
u94anrvVWSb6CMl2FqMATadDtuTCqTJOR+VPa9oA/VvDPvpkcEYXl9O4LEm19nAg
EMVy8oImQ75M/03kNPQ37kSoDDbU8siwfkwoHDgNl5WyQ+8QbXQ+vbRzCixXE8n4
VGtJe4qKtTGvRtWA6Fm7
=WHK7
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
