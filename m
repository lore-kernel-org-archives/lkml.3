Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3BEJ1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:27:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41551 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJ1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:27:38 -0500
Date: Tue, 5 Feb 2013 11:27:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/30] usb: ehci-omap: Remove PHY reset handling code
Message-ID: <20130205092726.GT32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-12-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1301281233590.1997-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aEcIyhw0mmnxygNd"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301281233590.1997-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aEcIyhw0mmnxygNd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 12:34:16PM -0500, Alan Stern wrote:
> On Mon, 28 Jan 2013, Roger Quadros wrote:
>=20
> > Reset GPIO handling for the PHY must be done in the PHY
> > driver. We use the PHY helpers instead to reset the PHY.
> >=20
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--aEcIyhw0mmnxygNd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENB+AAoJEIaOsuA1yqREsboQAJd+5i/GJ3aSMOqIQufG8UHT
20Pgfk6gOBA0PWO6f5B7LiyLo7TS9yalkg+miIuKtXCd7jVGC1l7YQDfpUuWpdc9
mNkfkx+NRFj0veZ7j+Z5PGVL56/WTxEdkiXBcTHIWemdr0XVfESAVvmR9OCRyKBP
qMGpTio1zPK17/FFIW9c9vhF2i5qH6/0w3GPw1axylETejfgD6BnXBe+taiwgc8A
a9EBywwm+UBGFvQGNuEBFk7GN3OaoMlNM/OwQ2O0W56DVXBN8r7bzEFDePHdqsN/
sHWmW3wD8CabWLwgRbsGrnjMcrp9cnVaFywdP7ASOdPX2DB5f6qEM4JvCyFzeAcD
ga4b6zLv88mH7pd/MkXGAdydcLNyJAxsQ9Pf/NsT6VYfDCQJFgPxSwkkDqOoTcIi
pXAmCmqaLWDASW5it34CY6YaWS+OzJyJ2sdaNsEzCOLWTXAAfoLum5NZXgNAn+UX
IUgKFOY79H7V9AV59JyDufBCQ9DS88K/5b6lxtd0va+gK/yjI1MgMpT/KPf2EY1F
427wg/7/T35/Gro9F0rta5I19iinsWUgLlbf/5doJeG3IskHIaP6m/kC/UrevMVn
QGXel3mJh8BCXzvb7rFcYwYZFmSNYYMlf9196FrDDcYZr38MoPmAW9eAiLTAsRyT
WDqM63PLEYqUFL9FhkMk
=u8/p
-----END PGP SIGNATURE-----

--aEcIyhw0mmnxygNd--
