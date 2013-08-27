Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3H0Szl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:55:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46618 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab3H0Szj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:55:39 -0400
Date: Tue, 27 Aug 2013 13:55:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Philippe De Swert <philippe.deswert@jollamobile.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget/composite : Avoid crash with bad gadget
 drivers
Message-ID: <20130827185506.GU3005@radagast>
Reply-To: <balbi@ti.com>
References: <1376072588-2881-1-git-send-email-philippe.deswert@jollamobile.com>
 <20130812180804.GE27954@radagast>
 <520C0741.3010905@jollamobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kdhy+KQ/ef+27j+Z"
Content-Disposition: inline
In-Reply-To: <520C0741.3010905@jollamobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kdhy+KQ/ef+27j+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 01:40:01AM +0300, Philippe De Swert wrote:
> Hi,
>=20
> On 12/08/13 21:08, Felipe Balbi wrote:
> >On Fri, Aug 09, 2013 at 09:23:08PM +0300, Philippe De Swert wrote:
> >>Some bad gadget drivers do not check the return status of usb_add_confi=
g.
> >
> >fix the gadget driver
>=20
> As stated in my comment (see below) that is indeed what should
> happen. But we cannot fix it in future new gadget drivers, is it thus
> not better
> to avoid a crash? The gadget driver will not work as expected anyway
> when this occurs and the print will at least give an indication why.

if we avoid a crash, we will be decreasing the urgency of fixing the
gadget driver bug.

Let's leave it as is. I can't live thinking that maybe in the future
there will be gadget drivers doing different things...

--=20
balbi

--kdhy+KQ/ef+27j+Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHPYKAAoJEIaOsuA1yqREeXcQALN/OtHRlqkZ2oZY1Wsj6lxK
ebwMkGsnvsz2EtDZm6JDrG8Y1WB/9HUjl6aMfMlMhI/feBoMYIz5NZFwHKcMUVxE
48AHJBKFIkhBzvVnAhVLX80tL24HW1wAiz8GFcY+FQDST0Cusckcr2glZK6Xa6bs
Y/iez9MAKivzYCYOZYhZFvwrIhLEl81l4RRQ34ZQvbKy57QJ4yJ/i8hESjy65w/t
xzncJiC9niIRa+kjDvSHF/5u9WrfDMwynqxApUoIFyMrJxg8LAptSuU0Kuu1LrOs
2w+7EjURztugKl5oGL274ImYwkRPZJ641uwiw3CRnbNM2pU7s/st1vduDmWoDbU5
eiiSunRdTiZCsF/7wud7GZTtRvBSFcJsM+X/SK6DJhLM6Ejr6Kg3tBs7qr0uXojt
oHbkv8lC00UNGdqunj1XUvlGsF4iLrKOteoNDCzA7UCK4fII6ZbB1b/ZxAgZaw2+
3Z4IyOaKKkBS+NqRy+Hxl8LXQ/n3aL3X8H5aVNClZmtYrpsGTgkQhJDHYjgXJKZt
o65oSk2PhjRObC/+t/8fm5mISv5QE6McMOHOz6m7SJSeYH5QqTAnFvkCKN2cRKYF
0/Y/RtZu2jfvy3Qj5MBYjB8lG0KvjpfVd8ApO59QykdkwvPCa881IbG0H1XJRSzP
gn4gEnuTVtCME4aRBuiO
=nPgF
-----END PGP SIGNATURE-----

--kdhy+KQ/ef+27j+Z--
