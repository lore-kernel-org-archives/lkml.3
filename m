Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3ATJ3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 04:29:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47860 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3ATJ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 04:29:00 -0500
Date: Sun, 20 Jan 2013 11:28:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
CC: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zihan@huawei.com>,
        <Lin.Lei@huawei.com>, <neil.yi@huawei.com>, <wangyuhua@huawei.com>,
        <huqiao36@huawei.com>, <balbi@ti.com>, <mdharm-usb@one-eyed-alien.net>,
        <sebastian@breakpoint.cc>
Subject: Re: USB: storage: optimize the matching rules and support new switch
 command for Huawei USB storage devices
Message-ID: <20130120092839.GC16066@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234359.GA2160@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <20130118234359.GA2160@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 18, 2013 at 03:43:59PM -0800, Greg KH wrote:
> On Mon, Jan 14, 2013 at 10:55:48AM +0800, fangxiaozhi 00110321 wrote:
> >=20
> > From: fangxiaozhi <huananhu@huawei.com>
> >=20
> > 1. Optimize the matching rules with new macro for Huawei USB storage
> >    devices, to avoid to load USB storage driver for the modem interface
> >    with Huawei devices.
> > 2. Add to support new switch command for new Huawei USB dongles.
> >=20
> > Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>=20
> This patch breaks the build, did you test it out?
>=20
> I get the following errors:
>=20
> drivers/usb/storage/unusual_devs.h:1530:1: error: implicit declaration of=
 function =E2=80=98UNUSUAL_VENDOR_INTF=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
> drivers/usb/storage/unusual_devs.h:1534:3: warning: missing braces around=
 initializer [-Wmissing-braces]
> drivers/usb/storage/unusual_devs.h:1534:3: warning: (near initialization =
for =E2=80=98us_unusual_dev_list[186]=E2=80=99) [-Wmissing-braces]
> drivers/usb/storage/unusual_devs.h:1534:3: error: initializer element is =
not constant
> drivers/usb/storage/unusual_devs.h:1534:3: error: (near initialization fo=
r =E2=80=98us_unusual_dev_list[186].vendorName=E2=80=99)
> drivers/usb/storage/unusual_devs.h:1537:1: warning: braces around scalar =
initializer [enabled by default]
>=20
> And it goes on and on...
>=20
> Care to fix this up and resend it?

Before resending make sure to scripts/checkpatch.pl and compile with
make C=3D1 for your ARM platform and x86 with allyesconfig, allnoconfig
and allmodconfig. In summary, follow Documentation/SubmitChecklist.

--=20
balbi

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+7jHAAoJEIaOsuA1yqREHDoP/3D6zPU5pdXdOsFvCkH7OCSW
6gUzHtYtLkqZl+fVeUIH9oCYa3z936rWvS9PlSRNF5zPH8PrS+8xU3EmaQcqAuP0
YqEt2AGVVPtOPxglfVi/TCVbECeoY2iueT+mmCXmQfIB79Kk3JaFYzM66MX81wQx
bY1XQzasSiIm6AXrF6R5gDaoDKVQr4y4oa3YDxkaKrQG6WBbU0GTYiitXapmtyQ3
zCKo0kK867M4dXtBOyCdgHZ0/BKE/FDqxhclqrdVnL/HYE/EBEtUH35o4cA2fU29
wxwhzivUXSYFox0mWn5H7SNSHAVMHT3okHLp2FE8Tz/ge6fYLMe+m/KVU4rkwdJ+
M92tYIZ/ZSkoQEAG3rDiUmAtmnWMoDJrdey6tqhPZZgh0niwavUCnfYe7UvKEHYk
0Jsd31pP2YuN/yvOAunaP4rFghnhebI7v3S91baDxrwCntud4KAA7Pd4lnb4ro+t
HPqIsqW2ahx2bSJycHaVzhOXH0USIkyFjimdRQyACMSo7cNQrAsT0i+ArufPpLFU
wHbFRNOv5F2mneK9m1j21S6DfKhwG9Sc1r3daWac9xutDF/NQKSJ/jdStYQffUqC
OqENGK1hXdOYKqMEj4eoW7JDtGscWWIlsw+TOjVKEZFWK5Sgv65GoI1uMxdVJfIt
DTjon3o/6Hyg2uhMGG0k
=yrqf
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
