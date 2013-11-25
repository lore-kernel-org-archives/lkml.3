Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3KYUES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:04:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35023 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab3KYUEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:04:14 -0500
Date: Mon, 25 Nov 2013 14:03:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Olof Johansson <olof@lixom.net>
CC: Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] platform/chrome: Add pstore platform_device
Message-ID: <20131125200344.GF18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385408226-22369-1-git-send-email-olof@lixom.net>
 <20131125195250.GD18046@saruman.home>
 <CAOesGMhd0r6h63Y+z-6CCuo2iHPCNA56Bg762K+G7XOHO8FRGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/6pUCPTUcpTjDznW"
Content-Disposition: inline
In-Reply-To: <CAOesGMhd0r6h63Y+z-6CCuo2iHPCNA56Bg762K+G7XOHO8FRGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/6pUCPTUcpTjDznW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 25, 2013 at 11:59:50AM -0800, Olof Johansson wrote:
> >> +static int __init chromeos_pstore_init(void)
> >> +{
> >> +     if (dmi_check_system(chromeos_pstore_dmi_table))
> >
> > is this check really necessary ? I would assume that your probe would
> > only be called if the device matches the dmi MODULE_DEVICE_TABLE().
> >
> > Except that you don't have a probe function which is quite odd. Also,
> > there's nothing using chromeos_ramoops_data, how does this work ?
>=20
> This is just a module that registers the device. The driver side is
> handled by pstore. See Documentation/ramoops.txt.
>=20
> That's also why the DMI table is needed: The module init is generic,
> and if built-in instead of loaded based on DMI table contents, it will
> always run. There's no specific device to bind against, since there's
> none in the tables passed in from firmware in this case.

I see now, thanks :-)

--=20
balbi

--/6pUCPTUcpTjDznW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk60gAAoJEIaOsuA1yqREgTAQAJqz5DcbIYe4sTPW9cpJT29l
2jl+tBCYID9RepJv96/nNF87gQcgUIOuRN1rLPahGGtgjafDTK/3MEig5/X4MqJ0
nWicyDD7f/UwXmuAE+j0U3TkuIzVKhJlZON2v14aYdzq3S6R/Vtrt+UPQWxns87R
VkUVQ371vuwe3DaMuVyc9kkAjmO5n0XyMgXV8MEyBFzim1Wx/j2G1/H/Fl4Zb/Ft
iGVRqn8uLR75LdT0Pdtc+mHSxBeGrLRUecXyjW+Ck5Q4lS6diqJb+DQlLuXqx2dG
nFho2VYINuaaNORONAWn9CDtQ+Pwq+in8DA4z+QvI5yzT/PGSJdXGFzqIgEohycv
pp/E7vCw6WEOljS20uf7bDBuvXhEsKaNFtXrevxnPkYm4qzpn1M9CM3DwjKc5SrH
BNiJ9v8+Ed333TGXGFo5XPdSLIgDPHy4yxFjsdCw1LNoefX2wDdAhfdmA8Kh2wJo
YeBgXk01ZScdrdqoK/YuaEq44gRKQjKxGeQ/vdCBhH8C/zxnkfljV0snC/PJdabH
sS+OIUD05slxtBc+NV15JtgN7sW7SU1kfpLfz1r9nqFSJppE2OigLg+JtwDlhoM+
5PdGhw0G7h854SNf8wD+G0KLmb66KYKEwGso4wLHblMbPgUooQaeZGRf92K+lrTz
QsWEkONhOVc7kwo7DOkP
=Tjmn
-----END PGP SIGNATURE-----

--/6pUCPTUcpTjDznW--
