Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaEFPpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:45:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34775 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbaEFPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:45:52 -0400
Date: Tue, 6 May 2014 10:40:14 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 04/20] usb: xhci: add a platform-private field
Message-ID: <20140506154014.GG25849@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-5-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cp3Cp8fzgozWLBWL"
Content-Disposition: inline
In-Reply-To: <1399335255-589-5-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Cp3Cp8fzgozWLBWL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 02:13:59AM +0200, Gregory CLEMENT wrote:
> This patch adds an xhci->priv field for private use by xHCI platform
> drivers. This field was present for OHCI and EHCI and it was not
> needed until now for xHCI. With the introduction of the clock support,
> then a private field will be useful, so let's mimic what have been
> done for the other HCI.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/host/xhci.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index d280e9213d08..054017f66246 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1584,6 +1584,9 @@ struct xhci_hcd {
>  	u32			port_status_u0;
>  /* Compliance Mode Timer Triggered every 2 seconds */
>  #define COMP_MODE_RCVRY_MSECS 2000
> +
> +	/* platform-specific data -- must come last */
> +	unsigned long		priv[0] __aligned(sizeof(s64));
>  };
> =20
>  /* convert between an HCD pointer and the corresponding EHCI_HCD */
> --=20
> 1.8.1.2
>=20

--=20
balbi

--Cp3Cp8fzgozWLBWL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaQJeAAoJEIaOsuA1yqRE0eIQAJ8f8Ky6nc6bPSl/VzLKtJF1
gCXhMvocUl2WwGUr/oikTPkgAXCChrQpAlfzhl7h3GLggOHV23yCND2/DdChHkQf
LwE4Mn7E06lUTTKYkdOrYQ6/Y2jXpOkyGK5kUB45wgu30k2RAXhBBGUAhu1kyjVo
ESV4sH7CoGeYda2WKa792r6GudpwGOXdiXnyJD8XBNuWU1GNSVkse51QebSjE2VV
jnZKB+KAIRZexOF4HNRHkoP5UiM2cZuvOo6ENvPqrGw3FEWXna22fjpnW9G1GiyE
tIB1LV/TkwAd/lm8i9tEl/ifyQxwffuS26XpRR9kXz8CmznFhJTTK/VyfQmDv5Y+
GE5AoRlR2SFcTLWKnVH+pxzlZ43qJ5Sv1PlxU00511IUofgI66dMrfJ3Q4mqY8tj
I+bNFojjNPYuh/zY/Pb7HKrPpYhWmTMC2ErNBLJaudKelcj1uhtnn+OnR30VV4RN
GVCwU1bzDHCLyVzROlBrpIY9GfIoB8l2CSkE2JiXGFNMosSES2QUpiEZaxtTkRDb
5/H7vW+Nq/AkjFRJsirh0FUhjpqMhv5V0y7Vr/okyqt5a7I+p3e3XfJ3Pux4r9Bx
ja66SMxeSDa/oKHnUnfbvxUdy20J0Ao79vkjA6gW0JkflhT1cEJk69M5TYr8nb+d
e2/YLodFIz1srGz+n17n
=tyjZ
-----END PGP SIGNATURE-----

--Cp3Cp8fzgozWLBWL--
