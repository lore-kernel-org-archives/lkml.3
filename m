Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab3CZSEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:04:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33047 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab3CZSEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:04:06 -0400
Date: Tue, 26 Mar 2013 20:03:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roland Stigge <stigge@antcom.de>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
Message-ID: <20130326180334.GL20785@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364319361-28265-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pFej7zHSL6C5fFIz"
Content-Disposition: inline
In-Reply-To: <1364319361-28265-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pFej7zHSL6C5fFIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 26, 2013 at 06:36:01PM +0100, Roland Stigge wrote:
> The current lpc32xx_defconfig breaks like this, caused by recent phy
> restructuring:

which commit actually caused this ? I need to know to make sure if this
should be sent to stable or not.

--=20
balbi

--pFej7zHSL6C5fFIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUeL2AAoJEIaOsuA1yqREx78P/2rdN5HNfjVJoJbdmn2VAzSW
7YgoffrvJeRzQLu2LPNkO4vIN53iclOxTM33/QLjHh7l9d1t9K1zaUT3fsvsZXjh
PbvdRe+ZK3IqiPnnzO3lgHLydnLgSQmlva1nL6s/flOEbc5Vx9Ti4mzssV9BXada
0zO+7/B3zOkI84u+DwGuADEptcDAEXxW932ynXTJY/0HVKSHpv5l9X5zxnVHOXbM
+lVY58Dw8D/VY4bBb4+4vPdKFUagUPsP4Y6UUVhCOtqPuZKWVh+KPrQ/UNfg+btP
dk841Hum4IozANEgQ6tLBEGsU02KoaSrJNQYrza2NTc0n/gsHzW1mfg+9TVMslQ9
4qiHhdS9jvAB15brA6SKsK2XAME4+s6M6yiJ/oc/RUcfKzuDwz4p3AQl24A4/J8G
BadBcvgW7YMTjH7dt2w5FR4MnDTPkOXslYNAFxdvXs4enfi22Zmdr8PT8G3xTWa+
M8+aGK09UUJ91C0FXki1fk0afDwoxmKAbyEe4ztmjLKma4/64F99XUA7ATBDEhfH
GkHczkIe6/rrmnK6ur6xgS1x7I8ueS5QROFlq+6X/v1zTQmlzzjECEwho4tgdaVe
ZOXLAev1b52xl11+cxiBaUkLrf5lNCvNpRHD1P/RwmhUzPKr+wwAsKYx0Ee9PnJQ
RzCy5ABrlCFigrFdHjZm
=NOsU
-----END PGP SIGNATURE-----

--pFej7zHSL6C5fFIz--
