Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3BEJOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:14:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50472 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3BEJOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:14:12 -0500
Date: Tue, 5 Feb 2013 11:13:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
Message-ID: <20130205091354.GJ32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359453032-20604-1-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2VXyA7JGja7B50zs"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2VXyA7JGja7B50zs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 10:30:05AM -0500, Alan Stern wrote:
> On Tue, 29 Jan 2013, Roger Quadros wrote:
>=20
> > For each port that is in PHY mode we obtain a PHY device using the USB =
PHY
> > library and put it out of suspend.
> >=20
> > It is up to platform code to associate the PHY to the controller's
> > port and it is upto the PHY driver to manage the PHY's resources.
>=20
> s/upto/up to/
>=20
> > Also remove wired spacing around declarations we come across.
>=20
> s/wired/weird/ -- not that people care about misspellings in the=20
> Changelog.  You don't have to resubmit the patch just to fix these two=20
> items.
>=20
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--2VXyA7JGja7B50zs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM1SAAoJEIaOsuA1yqRE6ZcP/3AoiV2HqmqYNW4EhdFZX53j
en0NpRDheb6bJEgvWqcu4bqtMWr4KPCDvVAxDYENjByY7s2xX0EUwRhOX9EZC9P7
qwEsWQ5cuOhb7pX1N5gJcfbGob8fZg8AdjixIWv3k+Wx729EZ7Ja3squdn05f7nN
HTlmcKclvMdQ7D8348GZD4OfslUKaeTOQrOW2Y8veaDg0pmQ2z0on5mpxqWvDvD7
aGq4tuJXgP8A7ZpTUOYWKYdD8JtOwbLuLkanCZBA6j1zoCu1gEtFqzULcWsgURIR
ZxYbsHtN7BTkhlstPLiSn6sXvfxcErRpQnG50tPkqYPKbxDqAbucfBA4ggOPMRg9
K+4sB5ZdVNqrmRlhWjQEFPrSM7SL0JeqPHwnrsRk9YoGZ+d8EwouICoWrYfP207t
puCZOmp3N7u8ShpuhnWAz9Zqorm67hL6TY5fY0N8ppyXY9qC0PiIIFu9ZuaCCF2C
l515SduwXiVAo9E7IIafABppEUfHpnsJrisbCRthwfwRQa8pkFtuWi57SQrxTTOF
c1DueP9dFworK92Kpv0+UVNVlsmcwv1HNFkLBPcjoG7ON9exLvcP7V0ebf5uL7FJ
V4OPFjGSj0KWacO83ley5E9I4zjPK2Y6wjkJRVc5T585i5ERltMzDPu3G01MyQ7O
hek1zhtn7U9e6NpeLYPS
=kf+0
-----END PGP SIGNATURE-----

--2VXyA7JGja7B50zs--
