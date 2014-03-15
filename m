Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaCOBkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:40:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59059 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaCOBkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:40:51 -0400
Date: Fri, 14 Mar 2014 20:39:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB : Gadget: fsl: add information message
Message-ID: <20140315013907.GC31520@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394716310-27001-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152600.GH4599@saruman.home>
 <2b425ae9fdcc4fe8959b4d366070cd0d@BN1PR03MB251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <2b425ae9fdcc4fe8959b4d366070cd0d@BN1PR03MB251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 08:52:49PM +0000, suresh.gupta@freescale.com wrote:
> Hi,
>=20
> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]=20
> Sent: Thursday, March 13, 2014 8:56 PM
> To: Gupta Suresh-B42813
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; =
linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB : Gadget: fsl: add information message
>=20
> On Thu, Mar 13, 2014 at 06:41:50PM +0530, Suresh Gupta wrote:
> > 	Message helps to understand that the Freescale Gadget driver
> > 	is up without any error.
>=20
> why this tab ?
> [SuresH] I will remove it in next version=20
>=20
> >=20
> > Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> > ---
> >  drivers/usb/gadget/fsl_udc_core.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/usb/gadget/fsl_udc_core.c=20
> > b/drivers/usb/gadget/fsl_udc_core.c
> > index 9a93727..455d0ab 100644
> > --- a/drivers/usb/gadget/fsl_udc_core.c
> > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > @@ -2503,6 +2503,7 @@ static int __init fsl_udc_probe(struct platform_d=
evice *pdev)
> >  		goto err_del_udc;
> > =20
> >  	create_proc_file();
> > +	pr_info("%s (%s)\n", driver_desc, DRIVER_VERSION);
>=20
> if there are no messages, then it's up. Also, you can very easily check l=
smod.
>=20
> sorry, but I'm not taking this.
> [SuresH] The legacy driver shows this message when module_init was
> used. To make same upbringing for customer, I added the same message
> after probe get  completed. This message will not make any difference
> but will satisfies customer need.  =20

#!/bin/sh

lsmod | grep fsl_usb2_udc

if [ $? -eq 0 ]; then
	echo "Yeah, USB driver is loaded"
else
	echo "Bad! Bad driver"
fi

Still not taking your patch

--=20
balbi

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJTI687AAoJEIaOsuA1yqREsswP90urJaI1FVwLhGEy1kSfQdsf
6YJ9xrYCrJURv4bjbybk+N/5wpciktWgNS1OGMKS4hA5IGAV412eVMrlEVKMuGlw
y+MuhHS4J7GRyHTWNYTMX94+juRCS69yPzjwyEWnbS+RSTJrC4zlvOcsHjDr9fuE
fO1cIwECP/fKxgNj0N5g+bkJYE6G/zIkfrXmYseIeL+zSu/+oPwtuNsCTHR15Z5i
+5sN/P30YY4ePbR9FbwuevodANcU8vMKaQbmhB2n0Hb1apOMAFa3IbOoVGBaGxlg
XsCHMgft/8zpEXIbMpl1LGlgrUvo4u0MwXpLVsBBL2ZF1tPTuIFfX28CefIJJZb3
oFnSNyu9dmNp4UE9Y6xWPY2GQv/1FvRFcMduu9luS6hG4Kc8Unrq+mqibJecbZtp
k+srAzzS2834eAdgFkH5ED3FxZXsM7tkZdpIwVUdHr7wMr825NgiqkB3v06o5JPw
9OHu08C+kudhtMB+lxabru3I5gsWp4RA4DwW8n79O+lFumTLUfL3edrpZY9+Ahki
uw3lDk0GIk7cGA0n6l0/mZy9zYoETpHcSj2S7mPtd/rt9wXhQ7fN0b0RWNdUa1zK
eg96b8EoxJv8+fXedHKqr90NRk2qRj5DKrFpLR/UOUV2QK5UtP/r0jecRXar98E+
rzK2aIL16ZDqHeFbVzE=
=yix5
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
