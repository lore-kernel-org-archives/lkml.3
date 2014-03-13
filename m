Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaCMP3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:29:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43870 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbaCMP3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:29:09 -0400
Date: Thu, 13 Mar 2014 10:27:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Suresh Gupta <suresh.gupta@freescale.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suresh Gupta <B42813@freescale.com>
Subject: Re: [PATCH] usb: gadget: fsl: Set dma_ops for FSL USB Gadget Device
Message-ID: <20140313152727.GJ4599@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394719632-27101-1-git-send-email-suresh.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ELVYuRnMxQ5nnKRy"
Content-Disposition: inline
In-Reply-To: <1394719632-27101-1-git-send-email-suresh.gupta@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ELVYuRnMxQ5nnKRy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 13, 2014 at 07:37:12PM +0530, Suresh Gupta wrote:
> From: Suresh Gupta <B42813@freescale.com>

return -ENOLOG

> Signed-off-by: Suresh Gupta <B42813@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index 35b20e6..2a43d9d 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2456,6 +2456,7 @@ static int __init fsl_udc_probe(struct platform_dev=
ice *pdev)
>  	/* Setup gadget.dev and register with kernel */
>  	dev_set_name(&udc_controller->gadget.dev, "gadget");
>  	udc_controller->gadget.dev.of_node =3D pdev->dev.of_node;
> +	set_dma_ops(&udc_controller->gadget.dev, pdev->dev.archdata.dma_ops);

why is the driver doing this ? Why is the driver given knowledge about
details on archdata ?

Why do you need this at all ?

--=20
balbi

--ELVYuRnMxQ5nnKRy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIc5fAAoJEIaOsuA1yqRER2UP/2uMxnmFEbWJco98x2exCfUS
PudRfHYJ7/M969U3jCEmX7YIBk5ZY9NcYnTy/aYCjzfoQfNul3kyq6Vm4E11bwMm
IQbJQtSQGIOZjizv7ccNEL8/B1oNbYBRNxoiI//D6oMfs6iwUQUXtfu0PH7Gg6Qs
1YuYBbJAkc7/QaOMBapnhoyOCln8fwnic2Wp8yGMp6CPAWDP+r17mw6ppwoznmFd
GaQHR9VN0Au6Rh2DmzFIegi3SzU9H5GSVDAmg4bHkaqbQi7N2D1/WcZBCFepQ3YW
k5VbyHMFudKaHgEBK4R1rO/jKDuzUox44I8vUupg1NXPYbHJvPurgbFiaRnYe66s
mvzwPt83ZxCY9Rq4/e4Rkk3zb/Js1eUCk9cFwSWHnvp7O98umiWqa+Pk/7qxo6NS
aZAO9eCdm9Tzu3YQyMXU/aYegqpmvxQs99yerr472i0ivv6Fnft5/WYEEX/h/7t1
8oHfko5OtlE+5Kr2xg5fX22FcGBBdyclyWF4H7X17/aPx80wudcCNmRk9NWPbSwu
sV1sRwwvOiHI3mSwkdTnw0YIqZ93b3ZEHPaw9DR7uqzF6tFFYbnLUy2Ko+LJ+cx4
OAMJOpDKRO8AmkAgye7dm9s1KJNxHXbqLQZjKGE9CsKBNygDaadbBHavZVl+07uN
hbL2hwLsx9VtzdDYjFzX
=O8ug
-----END PGP SIGNATURE-----

--ELVYuRnMxQ5nnKRy--
