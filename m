Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBNR2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:28:11 -0500
Received: from ring0.de ([5.45.105.125]:59498 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaBNR2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:28:10 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 14 Feb 2014 18:28:03 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20140214172802.GA26969@earth.universe>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <201312301531.29768@pali>
 <20131230145250.GA16904@earth.universe>
 <201401082236.25135@pali>
 <CAHYPw2EJC9RwgzXmGuQgh5_L6EMtS7MW8N3u2dR8KeVc0kb43g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <CAHYPw2EJC9RwgzXmGuQgh5_L6EMtS7MW8N3u2dR8KeVc0kb43g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pali,

On Thu, Feb 13, 2014 at 04:33:28PM +0100, Pali Roh=E1r wrote:
> 2014-01-08 22:36 GMT+01:00 Pali Roh=E1r <pali.rohar@gmail.com>:
> > On Monday 30 December 2013 15:52:51 Sebastian Reichel wrote:
> >> > > > +MODULE_DESCRIPTION("Bluetooth h4 driver with nokia
> >> > > > extensions"); +MODULE_LICENSE("GPL");
> >> > > > +MODULE_AUTHOR("Ville Tervo");
> >> > > > +MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
> >> > > > +MODULE_FIRMWARE(FW_NAME_TI1271_LE);
> >> > > > +MODULE_FIRMWARE(FW_NAME_TI1271);
> >> > > > +MODULE_FIRMWARE(FW_NAME_BCM2048);
> >> > > > +MODULE_FIRMWARE(FW_NAME_CSR);
> >> > >
> >> > > Do we actually have all these firmware files still
> >> > > available. If not, then focus on the ones we have.
> >> >
> >> > Firmware files are available for download from nemo project:
> >> >
> >> > https://api.merproject.org/public/source/nemo:devel:hw:ti:om
> >> > ap3:n900/bcm-bt-firmware/bcm-bt-firmware-0.21rc3.tar.bz2
> >> > https://api.merproject.org/public/source/nemo:devel:hw:ti:o
> >> > map3:n950-n9/ti-wl1273-bt-firmware/bt-firmware-ti1273_0.23+0
> >> > m6.tar.gz
> >>
> >> Would be nice to have them added to the linux-firmware.git.
> >
> Now when driver is queued for staging, can somebody add firmware files
> to linux-firmware repository? Note that without firmware files, driver
> not working...

I just had a look at the file for the Nokia N900
(bcm-bt-firmware-0.21rc3.tar.bz2) and I think the license is too
restrictive for linux-firmware.git. Actually I can't see any
statement allowing redistribution. For reference this is the license
text:

Copyright (c) Nokia Corporation 2010
All Rights Reserved.

This material, including documentation and any related computer programs, is
protected by copyright controlled by Nokia Corporation. All rights are
reserved. Modifying, adapting and/or translating, any or all of this materi=
al
requires the prior written consent of Nokia. Distribution for commercial
purposes not allowed without prior written approval from Nokia.

Anyways, I added Ben to the discussion (maintainer of the
linux-firmware repository)

-- Sebastian

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJS/lIiAAoJENju1/PIO/qaWT0QAIXbWMasGSKtuSIH7N+oP72g
Ccn5Um9PIVSJDC7jrA5xy6IO1AysnQXPsHyXjq7WoZBsaxwg7pEzyHHT9Cftqzje
YTfgb0debzMlBXvzx6fEJmGSHgRFhKSK3E3pe6oPIVzcFxj62I2bLcQnFe6lZ+hC
0G10fAFFGHclzaK1Gb6c58RcLM3QGDDiX6g7vygsJ10UX/Fzgdv3lPWfe8N8bxO9
LsmyWUZ6xqgaCoyz2VCiulNPBiqrNUjHK+qD6WkX1pOJ2sP8Bsnych8XmH6p8EC4
nHhGe/LWl4H05K5KEOiz534KDfzfIPOqqPOK/CAIDkxJ2HemLrsfyf5j8ttc8Hx0
hNRfDP8snUutQs4/46VQbBJ+7UfviXQSI48/Z8UlAqnmR9u9tyrKGSVyrX6xEjl/
NIaaaLpRonAc1zdTiZAOK8ZFn1cMOdL45M7bEoU1ezI7+yjZyfd634ibZVB2E7+U
dHFYFmup24adMP8mB46C8C3l/ckz4FDfuSyhusl1PYsAX6D18zk4BZzveZZXpnG3
9sIKSBi/aTdivPA0aJ2Pj8FEQA7RYw2KI1j2Ou86DrA8eK85TrKVvjpt8X2jv9b2
gUFzjvC5yTL0W/j2qdGRY+asN2ZgXGb4+XmbaBpbjx1p0UzefDMjBgj9EfIzmkVZ
zIMNxGJGGZYpnkf/ZBuj
=lU21
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
