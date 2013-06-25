Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab3FYNn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:43:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36923 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3FYNny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:43:54 -0400
Date: Tue, 25 Jun 2013 16:43:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Chao Xie <xiechao.mail@gmail.com>, Chao Xie <chao.xie@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
Message-ID: <20130625134324.GF20439@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130620121749.GF9817@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1306201319580.2063-100000@iolanthe.rowland.org>
 <20130624193643.GC11815@arwen.pp.htv.fi>
 <51C99D07.6030307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <51C99D07.6030307@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 04:37:11PM +0300, Roger Quadros wrote:
> On 06/24/2013 10:36 PM, Felipe Balbi wrote:
> > On Thu, Jun 20, 2013 at 01:25:31PM -0400, Alan Stern wrote:
> >> On Thu, 20 Jun 2013, Felipe Balbi wrote:
> >>
> >>>> In fact, the PHY setting and handling is related to platform or SOC,
> >>>> and for different SOC they can
> >>>> have same EHCI HCD but they PHY handling can be different.
> >>>> Omap'a case is the example, and i think some other vendors may have
> >>>> silimar cases.
> >>>> From above point, It is better to leave the PHY initialization and
> >>>> shutdown to be done by each echi-xxx driver.
> >>>>
> >>>> So Alan and Felipe
> >>>> What are your ideas about it?
> >>>
> >>> If we have so many exceptions, then sure. But eventually, the common
> >>> case should be added generically with a flag so that non-generic cases
> >>> (like OMAP) can request to handle the PHY by themselves.
> >>>
> >>> Alan ?
> >>
> >> I don't have very strong feelings about this; Felipe has much more
> >> experience with these things.
> >>
> >> However, when the common case is added into the core, the simplest way
> >> to indicate that the HCD wants to handle the PHY(s) by itself will be
> >> to leave hcd->phy set to NULL or an ERR_PTR value.
> >>
> >> One important thing that hasn't been pointed out yet: When we move
> >> these calls into the core, the same patch must also remove those calls
> >> from the glue drivers that currently do set hcd->phy.  And it must make
> >> sure that the glue drivers which handle the PHY by themselves do not
> >> set hcd->phy.
> >=20
> > perfect summary. Perhaps Roger could already work on private PHY handle
> > for ehci-omap.c and later we can start moving generic case to usbcore
> > without having to touch ehci-omap.c at all. Roger, any commetns ?
> >=20
>=20
> This looks fine to me. I don't have anything to add.

thanks :-)

--=20
balbi

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyZ58AAoJEIaOsuA1yqREK6YQAIVgv60U3o7uXTP9hZAAT5ra
Cvk2163gBZClXv4FtkzWwGBU3NHfe+BBJDdOiQXEEPpqGugPbpr89SyTKGguoaMZ
OVQXE2GYFMPyMr8RnUFRTYrbfZwE6Jnbo+ubZ06BF6TTws4bsxCIiTarrEvHxpLf
knVsq389qrKzH2drxy7DBXUus84wSGs5x7+11zTjeG3v1JFBndTgRmPd4Gq9+w8o
zkZRtIN0Om0sv5XXoGXA9ErtQLfb/OAXFlqkWfEsbFQJitd6cK3nkPcsBA/On+E+
0dwGZZB88bPYTYeJJD840/hv55Tz6gmKYx2S10OWVVaavM0V/Mc05pcMLZu8MabF
RTShLFWhq2iWEOKp2Qka6+vu/kKY6EOjFAxRaqCA6ZARgp/DADUYFkojduRtK2SD
gk/WPoHUnWaeIvCKkMUg8IUsabpwXVLXzfoF6iUhjW4lk+ydknBLk1MEku7uE0hO
uL9RRfmEFKzFTCbOsYDeHnXGNbm/5gMMCROZH0087ddZ3x4f+z4dyJYxmAZYBBZf
kfB9eDS/AcD/I+N2JvKb5gr/DsfK+pukg3uKLKNek9+k7PqT38RRx+SgSRnANHWl
A39Rd8dOVl1UjxcauDIU2n0jGi7JwoFSqcOB/dFyDK2atSSqxh1l+EsB+zPewEO2
6z3YNXaaJw2kav74g2Mb
=73CM
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
