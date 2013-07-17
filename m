Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3GQE0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:26:32 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46079 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3GQE02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:26:28 -0400
Date: Wed, 17 Jul 2013 06:26:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Wei Ni <wni@nvidia.com>, Guenter Roeck <linux@roeck-us.net>,
        rui.zhang@intel.com, lm-sensors@lm-sensors.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
Message-ID: <20130717042618.GA11359@mithrandir>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
 <1373615287-18502-2-git-send-email-wni@nvidia.com>
 <20130712152615.23464a6b@endymion.delvare>
 <20130712135000.GA3386@roeck-us.net>
 <20130712163034.1fc1cd66@endymion.delvare>
 <20130712144011.GC3629@roeck-us.net>
 <51E395D9.6070000@nvidia.com>
 <20130715092415.6d082aa2@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20130715092415.6d082aa2@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2013 at 09:24:15AM +0200, Jean Delvare wrote:
> On Mon, 15 Jul 2013 14:25:29 +0800, Wei Ni wrote:
> > On 07/12/2013 10:40 PM, Guenter Roeck wrote:
> > > On Fri, Jul 12, 2013 at 04:30:34PM +0200, Jean Delvare wrote:
> > >> If that means that for example the ACPI thermal zone is no longer
> > >> displayed by "sensors", then I strongly object - unless it is
> > >> explicitly registered as a separate hwmon device from now on, of cou=
rse.
> > >
> > > If I recall correctly that was the idea. Of course, in practice that =
will mean
> > > that devices will _not_ get exposed as hwmon devices, as implementers=
 won't
> > > bother doing both.
> > >=20
> > >> My idea was to make the bridge optional - you decide when you regist=
er
> > >> a thermal device if it should be exposed as hwmon or not.
> > >
> > > Yes, that would be a much better solution.
> >=20
> > I think we can decide it in the DT, we can add a dt property in the lm90
> > device node, such as:
> > sys-interface =3D SYS_HWMON;
> > or
> > sys-interface =3D SYS_THERMAL;
> > So we register it as the hwmon or thermal device
>=20
> This is an option, but please keep in mind that DT is not the only way
> to instantiate LM90-like devices, and we should not expose duplicate
> inputs by default. It is fine with me if the default is to create only a
> HWMON device (as the lm90 driver was doing so far), and only
> DT-instantiated devices have the choice.

I don't think this information belongs in the device tree. Whether the
device is exposed as hwmon or thermal device (or both) is entirely a
software issue whereas DT is a means to describe the hardware.

It seems to me that the earlier proposal of communicating to the bridge
whether or not a device should be exposed as hwmon device is the right
thing to do here.

Thierry

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5hzqAAoJEN0jrNd/PrOhQXgP/jYIUYFfrCEVA0amd99jVdp9
Tas04q9u/pBOoGmse32QaSrmNmxRkbCEzyGT+HWaij8+LYnd5NUPj1B9Z7pnd/hh
DikqXGgoogJQksVpLNTdYfkMcxCwtI/L0P2pm7yx/YCSRYJhGwfOqXHEy9XLpoey
/6MlXVWsA1iOvAvXynCjapk+feklF16gmGK3Wbc3bBavTGHZ8DvxlFs6WbVF2Eem
Wyc/kYVYnsRPy0xoSEyjycLnpyR/x3NuaIhxJs45fdinKoPzWtjStr+iE+6/R3Mo
dfQ2BIjIOtMDBmOQYS/dLAWraPKwfZItBte/mIxDkEUq0vVvF5IvvI/VZNtv4P6p
2nzFGf80h6G7UKrxQ7+8XCnuWH52hZz5UsrDlAOkcOPKobVRCcDMcfWbiydn9D6I
y5gugQ41RgnYZrt4/HZLU8xzbwcxviqrwxH2K0C5wzGmAwDCSEw+V1o6KZ4zD7sf
K00c9CwsaXi3+Hv6kgiKDe74gNb8nbSQFppp9zvYGOkLXRamwzTiJixnUu6nJ2+B
FyOBAp2YtM9XBm65K541blJXJhTVb9MaGgN2Sdlflo9QSJ9CZWHM0nowHfug1jYC
hMsbhaq1Rm4d/hR2TaZhj12gDdB9gPC/6jjk67LMoZ9pq9O5u/o7oGcVeXhSD7vM
TBSBiKomeTIEIVoz4gDs
=69qf
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
