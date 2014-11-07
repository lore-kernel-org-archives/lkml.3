Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaKGSI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:08:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35679 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaKGSI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:08:27 -0500
Date: Fri, 7 Nov 2014 12:08:52 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Peter Chen <Peter.Chen@freescale.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/7] usb: add support for the generic PHY framework
Message-ID: <20141107180852.GP15036@saruman>
Reply-To: <balbi@ti.com>
References: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
 <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20141107180820.GO15036@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="glwmnIOgU1tcuP7N"
Content-Disposition: inline
In-Reply-To: <20141107180820.GO15036@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--glwmnIOgU1tcuP7N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 12:08:20PM -0600, Felipe Balbi wrote:
> Hi,
>=20
> On Fri, Nov 07, 2014 at 01:33:25PM +0000, Peter Chen wrote:
> >=20
> >=20
> > =20
> > >=20
> > > Antoine Tenart (7):
> > >   usb: move the OTG state from the USB PHY to the OTG structure
> > >   usb: rename phy to usb_phy in OTG
> > >   usb: add support to the generic PHY framework in OTG
> > >   usb: allow to supply the PHY in the drivers when using HCD
> > >   usb: chipidea: rename transceiver and phy to usb_phy
> > >   usb: chipidea: move usb_otg into struct ci_hdrc
> > >   usb: chipidea: add support to the generic PHY framework
> > >=20
> >=20
> > Hi Felipe,
> >=20
> > I find you queue the patch 1st-4th and 7th in your next tree, how you q=
ueue
> > the 7th without queueing 5th and 6th, they have some relationships.
> >=20
> > Will you queue 5th and 6th, or I queue them (5th- 7th) through my chipi=
dea patch set?
>=20
> argh, somehow I missed them. I'll add both to my testing/next. Sorry for
> the confusion. I thought I had them all.

oh, they don't apply.

--=20
balbi

--glwmnIOgU1tcuP7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQq0AAoJEIaOsuA1yqREM4sP/RwqAhXKzdp82zjzalEgu+tK
CVthSJa8NWSVCvuam+6MkNqnWEzkQNEeRzk9LOiUG65HMwlp5S3izkYfCJBWSJ+b
WWjlfbbdIS9a+Pdn/ZmiPw2/EDM9yZdwRbElQtkPqgNXrBYrCAmdQcUpQl4wdG3M
2ApzYgRZg2PPZm+Jjt8M4M9RKRBp0yAj0wcD54RPWiQbWGEnfbzPt4kAKrQ13BuO
ZQ4qJ5kvK2gO8fKYr7B4W7LtQ2DFse1W9znUtm6lLONK/r2SRUpPVZOADUix1lP1
mAd5BlNWlju3Bkw7eqNzf5wD4e72K9TBGiSXTUebKrZrJL7qjd+y8YCO65/rluMz
1FeleJfiMyGuK638TuciDUVy4FpbCGV3Tkr+DMNev+Uwrdh7nXfMawbPtfCZnNsa
IM1D1TrVIzPfeejIBFriUaMJaNGvJfvYYBQTyo3CuKUN+j1EcebmLD8mA19xQ+SN
Q8XKNpn9kxjOSP3LmprgL16uY5vz/V3hyXw95HiLmARyQwqmrbAAlORH4MAHFZs+
1uqewblkl6RplX1Pi1FgHfdEn3qrzErIQCofgC0ssTFGTCsLnkyOA3cFe0a23HNP
hP1B0iEFf7OUjLWuclcgBU+8ZVs9QlEEXtxERaqtoqe63cptJNjYTVWTPIeMTG+F
GXE1cqD2RGRK/CPsqKNQ
=UGiq
-----END PGP SIGNATURE-----

--glwmnIOgU1tcuP7N--
