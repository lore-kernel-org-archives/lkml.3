Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3J3RdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:33:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43009 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab3J3RdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:33:20 -0400
Date: Wed, 30 Oct 2013 12:33:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stern@rowland.harvard.edu>,
        <Paul.Zimmerman@synopsys.com>
Subject: Re: [PATCH v3 1/3] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
Message-ID: <20131030173349.GO12193@gimli>
Reply-To: <balbi@ti.com>
References: <1383152778-30739-1-git-send-email-david.a.cohen@linux.intel.com>
 <1383152778-30739-2-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/6IVfYouxg+lu1D"
Content-Disposition: inline
In-Reply-To: <1383152778-30739-2-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5/6IVfYouxg+lu1D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 30, 2013 at 10:06:16AM -0700, David Cohen wrote:
> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
>=20
> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> to inform when controller's epout requires buffer size to be aligned to
> MaxPacketSize.
>=20
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  include/linux/usb/gadget.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 942ef5e..9405d0f 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -540,6 +540,9 @@ struct usb_gadget {
>  	struct device			dev;
>  	unsigned			out_epnum;
>  	unsigned			in_epnum;
> +
> +	/* epout requires buffer size to be aligned to MaxPacketSize */

please document this on the kernel-doc comment above.

--=20
balbi

--5/6IVfYouxg+lu1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJScUL8AAoJEIaOsuA1yqREk/sP/icX594H8il4dGGtvWJQ2tcw
QIGiPnkMl7CMtRmWX4yHrSPd+a54lBeJWyq9a+BClEzEngAxy0NtkeLSKWFlvITa
e5jQbzg0TOoRChjt2gerPmHuQKRosSYWxBnvOXTmg2eUQv413eZuSxFs0eqK5a8/
apR/HnGwgn+lDj50WSuOKq+WFZhGg4IsEHlVUqdAxSGtXkSnafLQ+m4P0YYFNLYm
aLE71K44aafKbqnSGV6wdql+aI9b3di5stWbEvUNDploVW57S2e6+wcaWa3mUy+K
6noLtFI/81BfkswwODba7sbr4iTHI/LF+hejWx3lXlfVEJkIMjW8NWkHHAX6ff0S
WiL6d152GN1XD9KwfSQoBfuqLSFXYUbrFZ56f/I5A8okTv/g4bkgnh7pF9KEPKYj
zPdLhw/sa1ibfG6VB7Mt8tUx8lpIZTQlUIe5stH0qeWzFK6esUti4bRL1ItFTr8C
IUrSXSO93M9dwlPWCiGWvPsCpAVJgJF0F4D+vC9xZ6r67iXMetKGMMR3IbE20H3l
EbgzrC7UU0BRnsTE9L/87cTHs+vFjw9m9a2SVHDspL2I4bRu8tbE0mnvl1h1Hb9Q
kHJsANvxOztugLaqFckYLZEq4T6vNpwBlfMIAOaAVX4wsw2Dndyk3SnDEdUSjZIz
EREY/2pGK8E8cW2gQFKC
=1DXF
-----END PGP SIGNATURE-----

--5/6IVfYouxg+lu1D--
