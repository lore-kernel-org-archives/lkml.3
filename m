Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3CNONM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:13:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40154 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801Ab3CNONJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:13:09 -0400
Date: Thu, 14 Mar 2013 16:13:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: remove MACH_OMAP_H4_OTG
Message-ID: <20130314141301.GI26080@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363032881.3137.101.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Content-Disposition: inline
In-Reply-To: <1363032881.3137.101.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2013 at 09:14:41PM +0100, Paul Bolle wrote:
> The Kconfig option MACH_OMAP_H4_OTG was already considered dead as of
> v2.6.36, as can be seen in commit
> 267ecec95f7d215d2da38252640b06198515acc3 ("Removing dead
> MACH_OMAP_H4_OTG"). Remove its last trace now.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with "make ARCH=3Darm menuconfig" (specifically whether setting
> either MACH_OMAP_H2 or MACH_OMAP_H3 still selected ISP1301_OMAP).
>=20
> 1) By the way "if ARCH_OMAP" on the next line seems superfluous, as
> ARCH_OMAP1 already selects ARCH_OMAP. Minor nit, actually.
>=20
>  drivers/usb/gadget/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 5a0c541..c65b5e2 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -194,7 +194,7 @@ config USB_FUSB300
>  config USB_OMAP
>  	tristate "OMAP USB Device Controller"
>  	depends on ARCH_OMAP1
> -	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
> +	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3

could you, instead, just remove the entire line ? we have an overuse of
select and this is one of those cases where it doesn't make sense.

--=20
balbi

--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQdrtAAoJEIaOsuA1yqREaHcP/jtJ8VK3i7ueK8J5Kht8q6h0
3nvMb0AcktdNsZfycn8YL8vOu45jvwAD/nizScSn+mMP83Co6rSIaJqWo4Cwo/ki
pEwe9mMIErP9bfNd7TDIngTJDa8G3IkmWBjHHeGJ05J2SVtAXMOdsUfF2mGpDLRQ
9WdMslVX7ZVAfnDwWmfXpKtbXhSkNU9bZjMxHcJoL9vZjwwpoJ/s0IoWDS/nW5sF
ZKwcAdZ6YbGQcvDCNezHu24KsN1qrTFgbWPeTgD/lioiK/5DkFnLLh4eaqX/NJVR
xPEoSvH4cb6C9YH4f9AMtIiZ+oLBCAqZkUo85GRz1s+ZtWkfZ+5GxPIS0WyRZnCA
94OBQUi819/XFVCv3sCGD6ce0rcDYx9oN4zAYbfXfpmLCRX219EZwg3mhxOdTAJW
vc/8+PYhkcY363cmEnVUcOpQKz7x2Fd+Iu1CwNdOyaQ3JY8w7v4Eku1ZCDl1nViJ
2Hh6JIJHGoWbDqLkQUlCkT5G64pjr4iMUHz+6Nc16Ymqca1fe7xRfH5KfLwEz9Tt
JHE7Q+9jO0jiY60zRjxi5iyALnM52S9B7O/gl4+n4pbEwCiHEEIuffNYl3hrlrly
xO6KSpTEK6sqDQ6BLrMyOpK5Kz4IFH6Jn3K82RNsHQZEMgI7PVHtgtG//Ct0C+ol
ZvU9XT46k8hHrMjaEpe3
=qKwq
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
