Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3L3NUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:20:30 -0500
Received: from ring0.de ([91.143.88.219]:50617 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab3L3NUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:20:12 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 30 Dec 2013 14:19:44 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230131942.GA13816@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Marcel Holtmann <marcel@holtmann.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development" <linux-bluetooth@vger.kernel.org>,
	Ville Tervo <ville.tervo@nokia.com>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
 <20131230121350.GB31236@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20131230121350.GB31236@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 30, 2013 at 01:13:50PM +0100, Pavel Machek wrote:
> [...]
>
> Well, I can rename config option, but renaming the module would break
> existing userland, no?

Why is the userland depending on the module name?

> >  Can we also make this just depend on some device tree information
> > and not on a specific architecture. I know that this driver is
> > pretty much OMAP specific, but if we want this upstream, we should
> > at least try to make it more generic.
>=20
> Nokia N900 is certainly moving towards device tree, but we are not
> ready, yet...

Tony plans to remove OMAP3 boardcode (incl. omap3-rx51) in 3.14.

> > > [...]
> > >
> > Please do not introduce public includes for a driver. This
> > should be all confined to the driver itself or if it platform
> > data, it should go into the place for platform data.
>=20
> (Could you insert newlines after 80 or so characters?)
>=20
> Where would you like platform_data definition to go? That indeed is
> for platform data, and quick grep shows drivers normally do public
> header files for that.

Probably it can simply be removed, because it's not useful in 3.14?

> [...]

-- Sebastian

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSwXLuAAoJENju1/PIO/qarfAQAJDXrQcdpTiJX9WaAKb9bnB/
8iCCMk/+dgfBlu/vycLeJ/oNT2INZwVCE7BpOq8b9hJFbTcKTBLKUgBtJbit89D7
PChXS3DUByEb6wxU6E5LxX/WW5BRzhhYA0GxiaJGA6gp743EEF7l6yU8w2kf97qF
8cqw0ZNXMb0ewMZ9NHo6lU26hNKHT7mvzn3b6wL1F/aoyS4BX+HZrhLD/F4ki89x
HXPDzYFnKC/7RYMSi1JsZMlSupB7jT16UXUHZXEM7wDnUJMTyrEA/t1CuRYJCHTZ
dZTc+fNGrJJDkXjWHnEey/idt+qoRr8vB6h3Zmp+omUnBe//SF7cgvLq6CP20sFG
j50Q81u9cTVUUwSI0jB4K9Ch3bTaIlevsVZszeg9VDosB6/8EGLJL/BuSamLxA7n
2rm2wfAQJD4D/6a193SfCsAL270fYY0et5+HqcEsbywVxkrYKPiqgdN6QmHUoQfp
fBKmiGSKYTVFUK1Bt6i9qf30LqOePXBfZJmRzYBrBT/+QqSzz+ONeFOTXiZ0bZ7s
4XoE8bPzgZ+8GJmZ7CWhPjZJMPNfA6C3c+jHRb0ls+VGc6X2XuZhY7gldbUA8mZK
wYj8fMC6y3tIlejUouvxKPM80/CzqCT2TRKijcy2NE+legGsIGVEq8dNWrqZ5FUi
GFbCmlCLFte/1Y8iMtrc
=5I6S
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
