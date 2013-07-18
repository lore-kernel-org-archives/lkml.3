Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab3GRLGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:06:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46150 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650Ab3GRLGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:06:46 -0400
Date: Thu, 18 Jul 2013 14:06:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Rong Wang <wr011235813@gmail.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130718110628.GI11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com>
 <20130717075706.GC5291@arwen.pp.htv.fi>
 <CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
 <20130717132736.GA7614@arwen.pp.htv.fi>
 <CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
 <20130718084041.GE11251@arwen.pp.htv.fi>
 <CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
 <20130718101058.GG11251@arwen.pp.htv.fi>
 <CA+k=oDwvA3eSy7xL7hyBVgjCm37Mv7iroFndJOC09ZQci0=o0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P7Tqkd/m/Jnohiaz"
Content-Disposition: inline
In-Reply-To: <CA+k=oDwvA3eSy7xL7hyBVgjCm37Mv7iroFndJOC09ZQci0=o0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--P7Tqkd/m/Jnohiaz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 06:54:38PM +0800, Rong Wang wrote:
> Hi Felipe,
>=20
> Here's the patch. If you are OK with it, I'll send it to the list formall=
y.
> Thanks.
>=20
> -------------------------------------------------------------------------=
------------------------
>=20
> usb: gadget: udc-core: make udc state attribute name consistent
>=20
> The name of udc state attribute file under sysfs is
> registered as "state", while usb_gadget_set_state
> take it as "status" when it's going to update.
> Here it is made consistent as "state".
>=20
> Signed-off-by: Rong Wang <Rong.Wang@csr.com>
>=20
> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index ffd8fa5..5514822 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -105,7 +105,7 @@ void usb_gadget_set_state(struct usb_gadget *gadget,
>                 enum usb_device_state state)
>  {
>         gadget->state =3D state;
> -       sysfs_notify(&gadget->dev.kobj, NULL, "status");
> +      sysfs_notify(&gadget->dev.kobj, NULL, "state");

just fix the indentation and prevent gmail from mangling the tabs into
spaces, you're good to go :-)

--=20
balbi

--P7Tqkd/m/Jnohiaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR58w0AAoJEIaOsuA1yqREBNwP/i6OU5V7WOMCiuYIrYtr62VT
G7uODk/m1ciUu3Hj6DIs8NY1uceEWxmOMABkLuxsYxm5UaRC6W1hhUy7kpbmkSAL
cVs00umqxH6I4npORzh76YwYFpDWdXon9zLamXXZYegn84pU8yagSYmb94ecT9Qz
443ohuqgPxVVQAslUkDD9mDHvk1syeyNZgOMmm7/dlR/er91IyRfLbVWlI1oFQ2K
h20q6GPZxOWmYM1AktRf5RVJaZlsZrWgPyTtIE0maCjxkhxDYam3+g8VhgjphmQQ
8JVsE5chOwCllJRIjV00ntVUKOru+uF2C0mj/wme6MHh9nTs3UVn+G9a9Nfgt9w4
eVIbT0+TlUS/LhdKc51ULIa9XTVdihf8hmp0w5s8uOnIUnkVa9pn01Ny7vuC98h/
6w3hMe7TA1GrvHuxc+WiV8QhOTwDE3agYkuiRhsvUTAT5ZjXPAPhC2cCrb8Ij8aY
09LIG/olVaZ95RKEK/EyGyzsowlgi4JZirVi1LZwV4IP97FuVnx1NnXKOLVDvQIO
x/zyM5qJx2VYwBe5MwpnbOhkNu9OtFt4JVA+LcUEMvzYMqL/+lOudTGYK4T0pXmN
7XrzE1uClBIl3k22l7eBqQLpSrIVTXCVWxsJZab/b3IWQO4VmuGDTOvL5FNvUBHs
bwbRwCDkplIzD3aMdnfK
=Xqo8
-----END PGP SIGNATURE-----

--P7Tqkd/m/Jnohiaz--
