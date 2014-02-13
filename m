Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaBMKGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:06:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57412 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaBMKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:06:00 -0500
Message-ID: <52FC98FF.20800@ti.com>
Date: Thu, 13 Feb 2014 12:05:51 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>, Tero Kristo <t-kristo@ti.com>
CC: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>	 <52F10C3D.7000507@ti.com> <1391767923.4937.110.camel@mars> <52FB748E.6050007@ti.com> <52FC8A78.1050500@ti.com>
In-Reply-To: <52FC8A78.1050500@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bs9L4nDHBH4XlFILvQE0ow5G1Qe1q3FRg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bs9L4nDHBH4XlFILvQE0ow5G1Qe1q3FRg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13/02/14 11:03, Tomi Valkeinen wrote:
> On 12/02/14 15:18, Tomi Valkeinen wrote:
>=20
>> However, I hacked together the patch below, which "fixes" the issue fo=
r
>> 96m and dss fclk. It sets the clock parents so that the x2 clocks are
>> skipped, and makes the x2 clock nodes compatible with "unused", making=

>> them effectively disappear. I only verified dss fclk, so Christoph, ca=
n
>> you verify the 96m clock?
>=20
> Aaand the hack patch I sent is crap... We can't skip the x2 clock path,=

> as the dpll4_mNx2_ck clock nodes handle enable/disable bit, which is
> present on 3630 also.
>=20
> I think the best and simplest way to fix this is by setting the
> multiplier in the dpll4_mNx2_mul_ck nodes to 1. I don't know why I
> didn't think of it yesterday.
>=20
> I have a bunch of other patches needed to get the clocks right, so I'll=

> send a series separately a bit later today.

I just sent the "OMAP: OMAP3 DSS related clock patches" series to l-o
and arm lists, which hopefully solves issues discussed in this thread.

 Tomi



--bs9L4nDHBH4XlFILvQE0ow5G1Qe1q3FRg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS/Jj/AAoJEPo9qoy8lh71AOwP/2QDs4IUVMucXwp5LhpYz+J6
OxLPL/GiR7UZRjml2fc6A0wvAyRqZkZ1xyJx68/xWcCq3hYlYpOFB4me5BtUkwT2
C2h4sYmBmUWZT2TDYKmzfvg+c6mGTXZeg0yzJV95krvGka+j2n9xw7wWlTfdENb4
F5CLRnvSEGSLknuceMfJoFtAtpmjgBoyrACfDezIGY0ys3c+guTt/yPBx7t3q97N
m7IHrYV4Hr2uXjZ15ta7Pa7waFaPeepCxrHFbeXZsMsVGOBFPgqMFR8g6Sf5Wob7
bVTdWval8szz7lut0YOJIGqjMkDlHvcXa4VjBLNVAGE6uFZx3khRZChPBiC13mmQ
7XbT0JjlI2GdoWMgGWdMV6Kzz2GDAlv8up/RSC36uFfgMsUxaawj20q3h59V9uCn
3eqAz19OqVJcl1l6MlPgAXSpyxylUU3R9uNJF/GSTslpOmxswEw3IRwZHLEJQA7Z
2DtgBzjXOmFqRlPpuwIE89H2xx9PCcC9+i6JMYgU9vWMDl+B33ELiPEVpmSQ1IuC
1KQGi8t2kCFphJQEvwS7H3WVdpbonEFXvGo90o3TiIzYcP4o+UEPtCPU0S6vfomG
VckILBwTXQIGoSnqCWd7WRcFQEywRQMKlBrUiTGnDUidHD53VUy7DXetc3EDXilk
0WrW14tsupMyQPA32IOL
=Kogz
-----END PGP SIGNATURE-----

--bs9L4nDHBH4XlFILvQE0ow5G1Qe1q3FRg--
