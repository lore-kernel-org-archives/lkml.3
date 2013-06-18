Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab3FRVfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:35:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54964 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307Ab3FRVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:35:39 -0400
Message-ID: <1371591331.3495.123.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 13/48] s390/pci: Implement IRQ functions if !PCI
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Tue, 18 Jun 2013 22:35:31 +0100
In-Reply-To: <20130618174235.GA32610@kroah.com>
References: <20130618161725.912524266@linuxfoundation.org>
	 <20130618161727.767561192@linuxfoundation.org>
	 <20130618173540.GP4752@decadent.org.uk> <20130618174235.GA32610@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Yram5/2YoCILt/prePNT"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Yram5/2YoCILt/prePNT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-18 at 10:42 -0700, Greg Kroah-Hartman wrote:
> On Tue, Jun 18, 2013 at 06:35:40PM +0100, Ben Hutchings wrote:
> > On Tue, Jun 18, 2013 at 09:17:39AM -0700, Greg Kroah-Hartman wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >=20
> > > 3.9-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Ben Hutchings <ben@decadent.org.uk>
> > >=20
> > > commit c46b54f7406780ec4cf9c9124d1cfb777674dc70 upstream.
> > >=20
> > > All architectures must implement IRQ functions.  Since various
> > > dependencies on !S390 were removed, there are various drivers that ca=
n
> > > be selected but will fail to link.  Provide a dummy implementation of
> > > these functions for the !PCI case.
> > [...]
> >=20
> > This breaks !SMP builds, so it's probably best to defer this until the
> > following fix is in mainline.
>=20
> Can you resend the needed git ids to me when they both go in, otherwise
> I'm going to forget about this.

If you forget then you'll send me a reminder saying FAILED, so I can
tell you then. :-)

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-Yram5/2YoCILt/prePNT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUcDSo+e/yOyVhhEJAQoy4g/9ELgnY0XAamP7JpxpJ2X+HPK44rS4sXqS
OheNd6xH3/IQCSIDVXTgLg1zIOuyYJkFBj9xolfjlEIQfslKbWLM9L0pwNb43sEp
TOGa8GEXVTHaP6pHfpNfT6NZ+4TM5Lc4nmXGGaQX+GcQxi9l/3FUF8FxHqK2zDAn
b/A2S27IHI6+WpLRrBDu+6uPYVNvKIfi31WOratw3Hl/Mxjhk2GtlMHgC/0QoGN6
vb8u+bRgnZgpMgCpakvt7pWdTU6exlU2ZUU2IWoUcZw6XPt0zXzOXd1Z/sE/xEjb
+hLje+5I5FVqJDeiwQ72pwln8wt9V5S4WQy0Qx2oEhLDsrCvOIpxJ+40seREtPkP
ed5lHi+iN5cgJ9PdjwMTdauCO948TeU3S8SoHchLeqrVDuFlXLCqWkKf0xSvbixh
hs+joZEk+O9IF8wvP/DJLZveWmm1wxEzWltwVuLiKaQKyE6W/TIrRbGWOW5SsUKo
IBbbpPJAghNLXNhNEq5jIIAASHphWUvCYCILwdVnBGLchz/3Vvm1nd+vEL+xI0wD
sUA5SWlRhrKAmsv8SnXnnVJp25Y4UYBNqbx1KEAcGQNmnAmcRGdY5bTzaS1cGGYL
iu9C20JHN/QEp33vKa30yKtKe885+WoyuAAnC0PHilvSeJaZGTDbPEaB+ZRi7Lk+
mu/gc69gmJA=
=vv1I
-----END PGP SIGNATURE-----

--=-Yram5/2YoCILt/prePNT--
