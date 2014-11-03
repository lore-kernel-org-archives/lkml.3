Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaKCSoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:44:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36622 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaKCSoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:44:09 -0500
Date: Mon, 3 Nov 2014 12:43:12 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Felipe Balbi <balbi@ti.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 09/47] mfd: palmas: Register with kernel power-off
 handler
Message-ID: <20141103184312.GW27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-10-git-send-email-linux@roeck-us.net>
 <20141103175645.GT12011@x1>
 <20141103175954.GT27425@saruman>
 <20141103183653.GA10558@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i/VKSWANvDZSIhsB"
Content-Disposition: inline
In-Reply-To: <20141103183653.GA10558@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i/VKSWANvDZSIhsB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 10:36:53AM -0800, Guenter Roeck wrote:
> On Mon, Nov 03, 2014 at 11:59:54AM -0600, Felipe Balbi wrote:
> > On Mon, Nov 03, 2014 at 05:56:45PM +0000, Lee Jones wrote:
> > > On Mon, 27 Oct 2014, Guenter Roeck wrote:
> > >=20
> > > > Register with kernel power-off handler instead of setting pm_power_=
off
> > > > directly. Register with low priority to reflect that the original c=
ode
> > > > only sets pm_power_off if it was not already set.
> > > >=20
> > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > > Cc: Lee Jones <lee.jones@linaro.org>
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > ---
> > > > v3:
> > > > - Replace poweroff in all newly introduced variables and in text
> > > >   with power_off or power-off as appropriate
> > > > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > > > v2:
> > > > - Use define to specify poweroff handler priority
> > > > - Use devm_register_power_off_handler
> > > > - Use dev_warn instead of dev_err
> > > >=20
> > > >  drivers/mfd/palmas.c       | 31 +++++++++++++++++--------------
> > > >  include/linux/mfd/palmas.h |  3 +++
> > > >  2 files changed, 20 insertions(+), 14 deletions(-)
> > >=20
> > > Acked-by: Lee Jones <lee.jones@linaro.org>
> >=20
> > missed lakml and linux-omap.
> >=20
> Felipe,
>=20
> unfortunately, get_maintainer.pl doesn't give a hint that this and the
> other affected patches should be sent to linux-omap. How am I supposed
> to know ?

yeah, just looked and nobody bothered to patch MAINTAINERS when those
files were added. I just sent a patch adding them under OMAP SUPPORT.

> Note that linux-kernel@vger.kernel.org was copied on the entire series,
> if that is what you mean with lakml. linux-pm@vger.kernel.org was also
> copied on all patches. Additional mailing lists were only copied for
> affected architectures to avoid for the patches to be tagged as spam.
>=20
> If there is a list named lakml, I must have missed it, and I seem to be
> unable to find a reference to it. If that is the case, my apologies,
> and please provide a link to it.

here it is:

Linux ARM Kernel Mailing List <linux-arm-kernel@lists.infradead.org>

--=20
balbi

--i/VKSWANvDZSIhsB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8zAAAoJEIaOsuA1yqREZlkP/AgEmVSiTPhI6LRmdH8SB64/
4NJqbmyyL+f4wVzx+7TUkqv1PFeZbdE6d07cpllXWjuevM0qNF/zmSffQW/oohKU
UGJ5o+G2i8+ukvdyRkRVquqIt2psoPHFbKW/xnRF2Oe2/ES1D28t6ovf07+0896I
3HiPBbKVPIuvpuTw8+6aE0o5+jnz4oN8n+M+OOmhvNfkVu89+zPaBZ8wtSs1en66
Fg/gv6ROCYpsgqqeJdNJZ6yanYO7vZcadT5A6WqzVUFsbg8YfX2Ed5zsyP1t6WZT
wPszuMc1jWhjldUemRg4QlAdkKNZP0zRhEiwhpqaHWkcVaxGQJR1GPyfLTLnaFWt
F63xvS8QhqVBtX5zFQm//lWnivUekrFc7FUseQzBjKzs+WqTVk0+fXHQ4f9CRQG1
pFo0oHu20qyEF6hXpDbYKcnTXjG3uBPILbSWdx+w5jYpfXQkhhdDKT4cNWDZl/Sf
jQZdk1ipGng+tq+mHZELGAM8ilg3epvKoS7VAfskBNONd/cyHB8nr0+YZnawz4ub
Xt42yZKyBntFpWTEddrRf1/Ycle7R23QJ0xb0MD0OlOo3UhelbSx2ivc++WdjkN1
7ksHRZ3c2zAS/xEh17ycmBggG/109gIJoI9/a3vhGk2qYaKb+J2EXjq2LNfn9RqO
rXB1540hY/Qu5RctDHu+
=qoUc
-----END PGP SIGNATURE-----

--i/VKSWANvDZSIhsB--
