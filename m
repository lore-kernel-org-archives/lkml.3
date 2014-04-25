Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaDYUx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:53:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43464 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaDYUxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:53:52 -0400
Date: Fri, 25 Apr 2014 15:53:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v7 20/20] usb: phy: msm: Use usb_add_phy_dev() to
 register device
Message-ID: <20140425205346.GN29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
 <1398354495-20782-21-git-send-email-iivanov@mm-sol.com>
 <53594490.7040205@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vjTL8WsyNLGAy3AI"
Content-Disposition: inline
In-Reply-To: <53594490.7040205@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vjTL8WsyNLGAy3AI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:06:24PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 04/24/2014 07:48 PM, Ivan T. Ivanov wrote:
>=20
> >From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> >They could be more than one USB2.0 PHY's on the platform.
>=20
>    s/They/There/
>=20
> >This will allow all of them to be registred successfuly.
>=20
>    s/registred successfuly/registered successfully/
>=20
> >Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

how about here ?

--=20
balbi

--vjTL8WsyNLGAy3AI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWstaAAoJEIaOsuA1yqREhs0QAIb4ECsDSZ0UZ2OAY4l2TLqv
YaXXg5X3G94WQny7hvaj6uuiCsr5GxQpt0dVkfqmArnrhXETSdpd01H+qo4JsXHG
v5k1qoOAEDwrGMYvjHHqGUS2MPc7KONFdyGmG7DKQWwNKnYwZXMQn+CBkN4EARA0
Ee4925+meOW/hKPmke4u9OZkAOI+pcGJgdun+DuijIRiCPaC6ZvWrV8tANvai+hw
fDgq6OHWBI+UPI265FahV+dJkYmI72xuel2ilp8pOZC6Iap+8f819xYgs56WHnl/
i3mgMaoypooejPMCF2LSthgF1GifGXbMSLCcoCQSTGjNA9gw3Y8EFO8AupEju6Pz
XZfZKKutYGvsicAY+5EHgfxNxfNDwZ1/ZIdlKvWnVex4cSyZfOEN2nCKujbd4j1f
/R1iF95AN8lEGLv7kGzIWbN6CnlWHwRXMY64EBrENDDK7cto7/THqQD3zCTEzFIg
WuxqvxOSv3MItqUShXIaZ7iyNotIAg+mqjUe8kiDIo0ZXvdGoQ6zAqHS0KXikBqv
GlWrtGAUtelo2+qwEHTGB1lknOpOb+qAtYOeeMQYeHAQB9/gz6EGy9vGKwv76bhf
g1SX0N6/1bYYxOA4nLAgaHqxpkQlF36oGt0KNWjmIU3rM6p7qa76bWbFNXFEY8mT
2uu8lAaYaLUHfMjIFLAc
=6o9a
-----END PGP SIGNATURE-----

--vjTL8WsyNLGAy3AI--
