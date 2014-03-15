Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaCOBmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:42:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56384 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbaCOBmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:42:00 -0400
Date: Fri, 14 Mar 2014 20:40:15 -0500
From: Felipe Balbi <balbi@ti.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Message-ID: <20140315014015.GD31520@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 08:52:19PM +0000, suresh.gupta@freescale.com wrote:
> Hi,
> Thanks for reviewing my patches.
> Please find my comments inline
>=20
> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]=20
> Sent: Thursday, March 13, 2014 8:56 PM
> To: Gupta Suresh-B42813
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; =
linux-kernel@vger.kernel.org; Gupta Suresh-B42813
> Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platfo=
rm device id
>=20
> On Thu, Mar 13, 2014 at 07:35:31PM +0530, Suresh Gupta wrote:
> > From: Suresh Gupta <B42813@freescale.com>
> >=20
> > 	Add FSL USB Gadget entry in platform device id table
>=20
> why this tab ?
> [SuresH] I will remove it in next version.=20
>=20
> > Signed-off-by: Suresh Gupta <B42813@freescale.com>
> > ---
> >  drivers/usb/gadget/fsl_udc_core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl=
_udc_core.c
> > index b7dea4e..35b20e6 100644
> > --- a/drivers/usb/gadget/fsl_udc_core.c
> > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > @@ -2654,6 +2654,8 @@ static const struct platform_device_id fsl_udc_de=
vtype[] =3D {
> >  	}, {
> >  		.name =3D "imx-udc-mx51",
> >  	}, {
> > +		.name =3D "fsl-usb2-udc",
>=20
> why aren't you just using chipidea ?
> [SuresH] This is our legacy driver for all previous and existing ppc
> socs. Many of our customers are already using this, and we need to
> support them on this driver. We do have plans to shift to chipidea,
> but after some time.=20

cool, you already have plans, so we will see a new glue layer for v3.16
right ? Which means I don't need to take this patch either.

--=20
balbi

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTI69/AAoJEIaOsuA1yqREkZAP/jbgs1u3YxXKifhsOotGZ9FT
kARs2kXfpaILkEmuNGVVUzLBlSJ10HNFYj0OFlBOYn+aBE9suVamlUdlQqY2nzpD
42r/4ISZgGt85eSaXyZQ8aLc5qKv9UkGHja7Q7NyZpzKGqOZ8+GWMTcZ54WyLu5z
sikPrAoyhyKkiZbOG9kZaHE/2G18/SRJCEu/b1XEMjzmUSxlLAyIqbreQD3lTErc
fjK0lHcpX3EyXnu8KTLCPinwaS/AyO9mz4yX5UUUMYR+/X3XsvnAD9dBfShgT1IH
ZxjTp0c5gvlIKTMuNV7Ze42PHThhSrJyERn6B5uNBSht8fZOMcepTP22q67XGNro
42ClZkFsKxiYf0w40S27ALpv1CQv8E1DyeMoHlBW53bgzZk8EN+FFaCECIwfZOuE
ZFnvtRFoALIHMXSJ5N0e8Utq5co6chhjvIMiu+NG/6DKFlnogkmXepH2NXiYtNm6
qnOr3NsHZqIzbVZzIfAw6mQsnf5fHGFi7Pdn9hZ2/InfjvnYVGRqgIwsE8GidxUn
ccPixG7Z0rGy/ktqskoleqEy/kvrOEd322X60J+lSuKBQlN8f5B5a0bbh/rAoaxz
43k74/v1ItPEhI3VGxvZuWLQ997P6H0yKxU/ZgoHTY5mARIhbihUARsY+Xedrn9x
zU0EIlu8zheAExLyREku
=N72T
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
