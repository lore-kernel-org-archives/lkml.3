Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbbANRjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:39:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34480 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbbANRjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:39:31 -0500
Date: Wed, 14 Jan 2015 11:38:12 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 08/12] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150114173812.GI16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-9-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dYuLH7fbMjVsPkFl"
Content-Disposition: inline
In-Reply-To: <1421252524-24452-9-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dYuLH7fbMjVsPkFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 05:22:00PM +0100, Alexandre Belloni wrote:
> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>=20
> Since non-DT board support has been removed from the at91 architecture we
> can safely remove non-DT handling code.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/usb/gadget/udc/Kconfig    |  1 +
>  drivers/usb/gadget/udc/at91_udc.c | 16 ++--------------
>  2 files changed, 3 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kcon=
fig
> index b8e213eb36cc..366e551aeff0 100644
> --- a/drivers/usb/gadget/udc/Kconfig
> +++ b/drivers/usb/gadget/udc/Kconfig
> @@ -32,6 +32,7 @@ menu "USB Peripheral Controller"
>  config USB_AT91
>  	tristate "Atmel AT91 USB Device Port"
>  	depends on ARCH_AT91
> +	depends on OF || COMPILE_TEST

will this build with !OF builds ?

--=20
balbi

--dYuLH7fbMjVsPkFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqmEAAoJEIaOsuA1yqREL+0P/3YX3k3c2uVOWLmK0zHpk6u/
FKpCVmEdRO4VpYuo35bLqrvjaHNY7ygKTPsJkQrK0oa8hVhM8FJx2NTQWs5go/eV
zpyu4p8PberpswkWu6n29xTaKzKS7lMfn16mBeuBVr5GoAYH7s9WA8OnLLKwFqlt
gfDISBYerVaTynzqOchI8daFyjc7fE3r0WRSnpEGb9OfdAwyzFCEgvpHbhABPChe
sI99BYKsxJygz+hVpYErYvnlm2a/EuljtWN/IajHPaC5N0T4ifNSr4aQi3WkE4ZP
F7vdvJ8T3Bg8rPPEykQvBnAlnSivo+DEBthBb58zfXgJZqxjVvqQHkMgDIk4+dvI
MNiXsrtHvAYaQxtBWwlNp6OJIpQKxqfa9m/ClX92R69MyygM7q9xif8FgKL4oh2T
LQj3oJUvZ9ZplRdU7b9RynVtlCpfEOUEQwmPXAZkGLrAwTKzu8iWNghNFWYzZBSe
b3+Lyc+OtW357CVwmxNBcww8lxfOs+z/tIxm3XoBRVOGjlhdzj4XKrRpjNSZticV
8CEMqmxzFpAh2yufP9iiwKYM3TXKb3JXZ27mdt0ADaax/mT6bX4qFHxi7HJ0Xwo9
+Q+A7rnl9v+UjYH5dXjq87+Cg/Ux6exrUGwhJvUR9J5tBcLGa3OwpLugP596KDdM
4ZMo8wXXO+IDX1VjDjKj
=xPP8
-----END PGP SIGNATURE-----

--dYuLH7fbMjVsPkFl--
