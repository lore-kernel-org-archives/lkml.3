Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbaGRP7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:59:20 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:11608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756692AbaGRP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:59:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag0FACNDyVNbdWOb/2dsb2JhbABZgw6EIck/AYEIFnaEBAEFI0QSEAsYKgICVwYTiEYBrDiXVhcYjk9kB4J4gU4FojqETIhOg0Y7L4ED
X-IPAS-Result: Ag0FACNDyVNbdWOb/2dsb2JhbABZgw6EIck/AYEIFnaEBAEFI0QSEAsYKgICVwYTiEYBrDiXVhcYjk9kB4J4gU4FojqETIhOg0Y7L4ED
X-IronPort-AV: E=Sophos;i="5.01,685,1400018400"; 
   d="asc'?scan'208";a="239650369"
Message-ID: <1405699156.2237.4.camel@fourier>
Subject: Re: [PATCH 25/25] ipack: Replace DEFINE_PCI_DEVICE_TABLE macro use
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 18 Jul 2014 17:59:16 +0200
In-Reply-To: <1405697232-11785-26-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
	 <1405697232-11785-26-git-send-email-benoit.taine@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KLAWCSPT17FZmHavL5q9"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KLAWCSPT17FZmHavL5q9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-07-18 at 17:27 +0200, Benoit Taine wrote:
> We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to=
 meet
> kernel coding style guidelines. This issue was reported by checkpatch.
>=20
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
>=20
> ---
> Tested by compilation without errors.
>=20
>  drivers/ipack/carriers/tpci200.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tp=
ci200.c
> index c276fde..de5e321 100644
> --- a/drivers/ipack/carriers/tpci200.c
> +++ b/drivers/ipack/carriers/tpci200.c
> @@ -618,7 +618,7 @@ static void tpci200_pci_remove(struct pci_dev *dev)
>  	__tpci200_pci_remove(tpci200);
>  }
> =20
> -static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) =3D {
> +static const struct pci_device_id tpci200_idtable[] =3D {
>  	{ TPCI200_VENDOR_ID, TPCI200_DEVICE_ID, TPCI200_SUBVENDOR_ID,
>  	  TPCI200_SUBDEVICE_ID },
>  	{ 0, },
>=20
>=20

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Greg, Would you mind picking this patch through your char-misc tree?

Thanks,

Sam

--=-KLAWCSPT17FZmHavL5q9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJTyURUAAoJEH/0ujLxfcND7QoQAIDX6NNis5JdzN8szX3bYEYC
NF6fDbRZIFwBxFbIdJh2NsrJIHCA92WuBYg0Kqs3ETxOtIXUyUMxmJjHugDwwJW6
QGd+SLLdosCTyrfzzduGcHXXHIoAgo1LIJkn+nK97DLnHUy8LjvevciKtsfVbEcJ
SmEg2l2vImacApTrfUptt++S3ZCwv/BpIl/5sgdiBfyYypntVKHjJ09beWRYGP4+
a7GnYvrBen/5LNIZPOnrJ37m9wjdgOyisSrz5djiP5rvhEB4kmVy3bdWr1yYngqo
qqBo+3VKzv7xVlyq0RFW4PlvNtHJG0wnq0ijVG1Bsh6GrKBNx/WMOqF3Dgqc5pIA
WFvYRPz0usVBwDTox1kgb1uKA7lBKcM7kNPRbypB8OjFeJnoi11KuokE0jg9oIr6
SOYaKMF7jH/jZZtTEmnEoN8s63AOrPvAEi8rhNGfDXKeAyEyIY2sRPnmmn7i9OG4
XMizqix4vlr30FOyTKUW9H0WW5iVB8bX4Ut82tnCXwDjU2NxooSj2q+WNSP9m6rc
qdgoApzw/Ll0PbwQwUSP/UQOs0ZniApArYtpGMDNctFdZRhRZxsiOgBKyYpSl54Y
Z+iNwQSE1qeMlu/mXgL6GhliujpfrfydsCX9C+stFoFjo/9ewGaVhTnRD1ofJCKT
lUbY/tYPK7A4mr8HbryV
=Zm64
-----END PGP SIGNATURE-----

--=-KLAWCSPT17FZmHavL5q9--

