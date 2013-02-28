Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3B1AGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:06:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab3B1AGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:06:09 -0500
Message-ID: <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 019/150] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>
Date: Thu, 28 Feb 2013 00:05:59 +0000
In-Reply-To: <20130226235526.246172467@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
	 <20130226235526.246172467@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0hmGrq9gCezUxjdT71rT"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0hmGrq9gCezUxjdT71rT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-02-26 at 15:54 -0800, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Michael Chan <mchan@broadcom.com>
>=20
> commit 85f024401bf80746ae08b7fd5809a9b16accf0b1 upstream.
>=20
> It was mistakenly defined to be 24 instead of the next higher number 25.
>=20
> Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Stephen Hurd <shurd@broadcom.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  include/uapi/linux/serial_core.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -50,7 +50,7 @@
>  #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
>  #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
>  #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
> -#define PORT_BRCM_TRUMANAGE	24
> +#define PORT_BRCM_TRUMANAGE	25
>  #define PORT_MAX_8250	25	/* max port ID */
> =20
>  /*

Hang on, this is a uapi header - are these numbers actually used by
userland or are they really internal to the 8250 drivers?

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-0hmGrq9gCezUxjdT71rT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUS6fZ+e/yOyVhhEJAQqrRQ/+O1ss1ykv1BvwOpPdUUKoGQCR5uyaeO0t
HquSMZBv/sahizRjbaygdNXLlF24YfbJZ3hECkEVP0cHA3UTcA6FsqmWx/eNjjtO
VYyfZ/jFWkyLxD03P360iTb/ehewj3a/d4RukGriAmW77qIviLbII9Pub+YXlJaE
DZ+JUmD9HzGb856+fz6zx6YeZRQdh3Z89dXr4c77uSfkwS5bKeKQKgfn7EyimhkV
lhEEU2nHQqc0JXzomUes4NfSD69fSI9rthz7BuVt1rAlCdARjrc2F3K6tx6ISkez
A2V3Mg6tXGAGuHSTv4LwVVQ703RNkQAX+0+GNKZhgUcEtBC25UPcjsj0R+i5DJxf
BMtLRPBGaWQXbMiBteubwmOkfjr8LLMRkfQO10EFGa0Es/qsUXLuZXGz1Ca6gGzg
/XtX0oWgF9Z9XsufiM++dS6Jrls8L5uiz3bPL0ipRX1PTlMz84iOl7D89YPjX3DQ
U4PV/ziLcLFs9AH9sTrz3KtwT9Do+q8m0xhUrQMBdWD/3ym4By6N11t+MmB1RbP7
u60U9xbyuGB5y9t1c7gjNNoIOMHfJB+OhwVtN8eyC7BFK61lrwFbq3+xB5W1CSkF
yBo7cElBLIuz4a2CHqSElwYnl0mEL1murI6ovZPeyv9VsZEwd/THAtg2q2y6WGF7
vurj185313g=
=VZat
-----END PGP SIGNATURE-----

--=-0hmGrq9gCezUxjdT71rT--
