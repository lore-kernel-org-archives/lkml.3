Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbaEGPK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:10:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55070 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaEGPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:10:54 -0400
Date: Wed, 7 May 2014 10:10:08 -0500
From: Felipe Balbi <balbi@ti.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: <balbi@ti.com>, Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140507151008.GD769@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
 <20140506153953.GF25849@saruman.home>
 <20140507122326.54f3febc@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xB0nW4MQa6jZONgY"
Content-Disposition: inline
In-Reply-To: <20140507122326.54f3febc@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 12:23:26PM +0200, Thomas Petazzoni wrote:
> Dear Felipe Balbi,
>=20
> On Tue, 6 May 2014 10:39:53 -0500, Felipe Balbi wrote:
>=20
> > >  config USB_EHCI_HCD
> > > diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
> > > index 7530468c9a4f..7a8db7f7dc01 100644
> > > --- a/drivers/usb/host/Makefile
> > > +++ b/drivers/usb/host/Makefile
> > > @@ -19,6 +19,7 @@ xhci-hcd-$(CONFIG_PCI)	+=3D xhci-pci.o
> > > =20
> > >  ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> > >  	xhci-hcd-y		+=3D xhci-plat.o
> > > +	xhci-hcd-$(CONFIG_USB_XHCI_MVEBU)	+=3D xhci-mvebu.o
> >=20
> > hmm, this has the potential of resulting in:
> >=20
> > 	xhci-hcd-m +=3D xhci-mvebu.o
> >=20
> > I guess it's best to turn this into:
> >=20
> > ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
> > 	xhci-hcd-y +=3D xhci-mvebu.o
> > endif
>=20
> I guess you meant:
>=20
> ifneq ($(CONFIG_USB_XHCI_MVEBU), )
> 	xhci-hcd-y +=3D xhci-mvebu.o
> endif
>=20
> Right?

correct :-)

> If so, then what about instead making CONFIG_USB_XHCI_MVEBU a bool
> instead of a tristate? It's more an option for the xhci-platform
> driver than an additional separate module, IMO. What do you think?

fine by me too. It simply adds a quirk callback to xhci-plat.

--=20
balbi

--xB0nW4MQa6jZONgY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTakzQAAoJEIaOsuA1yqREwfEQAJBL7O3PXnZSswB6kDXKSmIu
Ps8lqIJ6lozGmDcaOAlekqVUEyouCEFxqyC3hGiIAYalqeGT+joiqUGcDrGYoKzv
uVGR2B+8Fm2a545cifyKhYsxMP1PlCjtT0/QGOGcioOzsbLAFlBxJHc1sOw6lYRr
bF0LM99aYr+2fMFUIVp+uL9gZ/gCULnRImmSRBa8O9o1FL2VeD1ov03BO3FG07EG
cdY15hp46BJYvZ3QOFruTOGQSP1HqrMNdg5vJV7L0MsHB6gnmoZltN4T7Ahd8aoa
dRIu0vczUCHjD2U9yAMy2e04sdZ5wpP/Tn4KasPmdlfX2pI1O5cLiUMdHz5ZwATu
9ykhoWcNW0PvEUz6Wf895TvamKM5430K+JxOQdgRJESAM23dMSjZ02gXoXoJTt1v
kh6GwG41s74OkSVU+40gWlKd72gkcxwbi2Mqh/CPsxnkhvvraC7ecyqpXcV0SNZS
gejNMi6Us05gBx7pazgrfjD9MloS1vUduE7dAdIhS61qJnhxZ/aSRfmA2/hdzNTj
F9z5lP9NK516nzYU1M4bgxCJ8+zED2YXMO3A35xqcxqsxXoXVYKgXZbEDKeQd4RF
HP6txbPtU4oFK7okJuJ8U+jb03wjN99x/adACqa7ImxukK/ozG4YVvLMvP31NNmC
BNs8jbjhUfEuK1NTMngE
=kBvc
-----END PGP SIGNATURE-----

--xB0nW4MQa6jZONgY--
