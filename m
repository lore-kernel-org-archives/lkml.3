Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaB1JGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:06:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56663 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaB1JGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:06:07 -0500
Message-ID: <53105171.1060102@ti.com>
Date: Fri, 28 Feb 2014 11:05:53 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>, <linux-fbdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kys@microsoft.com>, <abgupta@microsoft.com>, <haiyangz@microsoft.com>,
        <jasowang@redhat.com>, <devel@linuxdriverproject.org>
Subject: Re: [PATCH v3 1/4] vmbus: add missing breaks
References: <1393247831-5271-1-git-send-email-kraxel@redhat.com> <1393247831-5271-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393247831-5271-2-git-send-email-kraxel@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="LcP43K9g0fejLmsiux8KXARiGt2rGVkUv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LcP43K9g0fejLmsiux8KXARiGt2rGVkUv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24/02/14 15:17, Gerd Hoffmann wrote:
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/hv/vmbus_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index b37c91b..2352ae48 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -899,10 +899,12 @@ static acpi_status vmbus_walk_resources(struct ac=
pi_resource *res, void *ctx)
>  	switch (res->type) {
>  	case ACPI_RESOURCE_TYPE_IRQ:
>  		irq =3D res->data.irq.interrupts[0];
> +		break;
> =20
>  	case ACPI_RESOURCE_TYPE_ADDRESS64:
>  		hyperv_mmio_start =3D res->data.address64.minimum;
>  		hyperv_mmio_size =3D res->data.address64.address_length;
> +		break;
>  	}
> =20
>  	return AE_OK;
>=20

Why is this sent to fbdev list? Is this related to the hyperv-fb patches?=


 Tomi



--LcP43K9g0fejLmsiux8KXARiGt2rGVkUv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEFFxAAoJEPo9qoy8lh71pCYP/jifQl8QGGBDjTldTEGU6OZg
XWqoDnZN/KX6ClzSJqjTwZPnXXweX4Vc6bXFQAHfO9QWPyGq99Bmth94Qyt9mGRl
lA2kVzM/ZI6ZkW1jq/H2bv5+YkpRFNTbqUBLgeqhlgWRBuS+eHhS0fwYeQdrmx15
UpcE5J9wriyZiu4rAQm2N/KDKNbFgEHGyFD2chFUZG8gjM5PFtLAmK79Pu6OP2Wc
STRuNrIrsrxlSo/nqz5KPFctREIcHCZCF4sDAakHFfIdK02mkwR/sX+myyhMZCo+
QMohvBlEI/8jxFWnVxNlpq5/PsakVpQBZ5MOoUqkP+WgSkWd9CMAhIw5R7LaMA7h
987Dho3A7ehW/YB95m/X3HrCmjDgCY4RyW9AE0nkUoJwuuxegZMcxSQpPI3gO8EO
I86jzpT7K8MKcXAJtp2o9rpZVNzxGREgE2PjU+am35oLwaVNqAxtKXhE90zCQHfL
nCH1b0InfdGZ2pslsSXzKHS55OhPdBJNdCXnAZWZBPi55SPj0s4FIkaLUzmNS/vQ
rutNU3aCXK1VE2YfZvI3PTmYhudi+O3rFg443WwF2s6z3vwzUeC/fYIhNMeG4tjT
T5VfJcCW4tsfJxIpJcNjBd2wZAK77phorBOdiG2PsMlnup8q/8Wj7Oxy2AXyJVJ4
yD/eKKd6gBbbkY0q6Pw0
=mae8
-----END PGP SIGNATURE-----

--LcP43K9g0fejLmsiux8KXARiGt2rGVkUv--
