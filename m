Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3AUSni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:43:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39319 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3AUSnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:43:37 -0500
Date: Mon, 21 Jan 2013 20:42:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Message-ID: <20130121184237.GC10106@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-14-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1358788568-11137-14-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 05:16:06PM +0000, Arnd Bergmann wrote:
> In linux-3.8-rc1 it became possible to build the imx and
> mvebu platforms together in a single kernel, which clashes
> in the ehci driver.
>=20
> Manjunath Goudar is already working on a patch to convert
> both the imx and the mvebu glue drivers (along with all
> the other ARM specific ones) to the new probing method,
> but that will be too late to fix v3.8. This patch instead
> adds yet another hack like the existing ones to allow
> the ehci driver to load both back-ends.
>=20
> Without this patch, building allyesconfig results in:
>=20
> drivers/usb/host/ehci-hcd.c:1285:0: error: "PLATFORM_DRIVER" redefined
> drivers/usb/host/ehci-hcd.c:1255:0: note: this is the location of the pre=
vious definition
> In file included from drivers/usb/host/ehci-hcd.c:1254:0:
> drivers/usb/host/ehci-mxc.c:280:31: warning: 'ehci_mxc_driver' defined bu=
t not used
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: Manjunath Goudar <manjunath.goudar@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>

NAK, should be converted to the new usage of ehci library driver. Alan
Stern already implemented for a few drivers, help is very welcome.

--=20
balbi

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/YwdAAoJEIaOsuA1yqREUS8P/2BDBKzJdefYwZLfjQhnDKLq
Av85tWu1dbyivkX2pU0EbStE1H7SzSXafASL4BArT4b+9C1NJfj46xWE/Cefl/B+
em1UjC3q2nbhRxsVxy8kKJGXJe3tRheUCgju9cWgumpSfOjC3sJHpBCatGVYTIlX
1Z5O3D7t1K7+TcOu24mFHZogcJrH3IL4jVXujiUyQ1klB6wVQo1H/cw/tJCM09E1
oGWOVLqps3H1ozrIMx0EyfkboGrVLo4s7f/nhLLZjDTu5QGUEINRqFhOFWUheexS
SW8dXkd7fPhTlTFREjlBGcdUzfTjSG5wv3co+6cmMLM1rOZD0c4XzT1GHGZiODlw
qWvm/AY43GNcFxferygItAS4EWBxe26clr7TMFaKHoWvX35pc7KCC3Ds+0WRbjc9
rVAx4aIEeGCoGW+w3nOnBabh3zYGLbbxlIzWp0TN25+/B4GQCVHfu4c7GMob9f7t
1JD7f5CQFno3xOth6HNsm+tKsZo5EEJUWgiz/TLdvmhtP7D4XDEU2r85R5S/ske5
ptKQTASa5Ib3YaYpjP+Ud9jAHXCzOywdnF8z8HwpdnrTcuqmIpeKjlme93q5UZj+
dI3uELgM/AqV1xSXmsqsni2Ilndl2Q3V1mgBEjtlsK8/72m6NpCfusqqazdE3olX
fZPO7uTIOOxTWRgifq/O
=d98Z
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
