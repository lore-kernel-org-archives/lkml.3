Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3FRO7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:59:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab3FRO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:59:35 -0400
Date: Tue, 18 Jun 2013 17:57:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 5/9] ARM: OMAP: USB: Add phy binding information
Message-ID: <20130618145725.GC10318@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-6-git-send-email-kishon@ti.com>
 <20130618094438.GT5461@arwen.pp.htv.fi>
 <51C030B4.5070707@ti.com>
 <20130618102725.GB7843@arwen.pp.htv.fi>
 <51C040E8.2050904@ti.com>
 <20130618123536.GD8620@arwen.pp.htv.fi>
 <51C074C4.5000601@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <51C074C4.5000601@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 08:25:00PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Tuesday 18 June 2013 06:05 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Jun 18, 2013 at 04:43:44PM +0530, Kishon Vijay Abraham I wrote:
> >>>On Tue, Jun 18, 2013 at 03:34:36PM +0530, Kishon Vijay Abraham I wrote:
> >>>>On Tuesday 18 June 2013 03:14 PM, Felipe Balbi wrote:
> >>>>>On Thu, Jun 13, 2013 at 02:13:55PM +0530, Kishon Vijay Abraham I wro=
te:
> >>>>>>In order for controllers to get PHY in case of non dt boot, the phy
> >>>>>>binding information (phy device name) should be added in the platfo=
rm
> >>>>>>data of the controller.
> >>>>>>
> >>>>>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>>
> >>>>>I would rather not pass strings around, any other way to handle this=
 ?
> >>>>>Why do you need to pass this string ?
> >>>>
> >>>>Our old way of binding the controller and the phy using device name
> >>>>started creating problems after the devices are created using
> >>>>PLATFORM_DEVID_AUTO. Infact non-dt boot is broken in mainline for
> >>>>OMAP3 platforms for which I have posted a RFC series
> >>>>http://www.serverphorums.com/read.php?12,708632 which also uses
> >>>>strings.
> >>>>I'm not sure of any other way to deal with this.
> >>>
> >>>have you checked how other frameworks handle it ? Regulator has some
> >>>sort of binding in board-files, but I guess it passes the regulator
> >>>name?
> >>
> >> From whatever I could make of, regulator has 3 ways to get the
> >>regulator one of which is using the binding in board-files (but it
> >>also uses device name which could create the same problem that we are
> >>facing).
> >>
> >>1.) from dt data
> >>2.) from _supply_ name
> >>3.) from binding in board file
> >>
> >>(referred regulator_dev_lookup() in regulator/core.c)
> >
> >right, spot on. Which means we don't have a better, more elegant
> >solution now. Let's go ahead with this.
>=20
> Ok. So I'll drop RFC and resend this patch series
> http://www.serverphorums.com/read.php?12,708632

please do :-)

--=20
balbi

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwHVVAAoJEIaOsuA1yqRE/xIQAKkSfzTGbOgTjk/aVpwQkX14
weP27doju84ojh1TrcsaxYIyXj+pDnWRH1mkXgwp5q1JZqPFvvMvSGn8s16i29bt
txvkMNOutJ7LCWvb1YQfOZyXn+vsVxTCVIKPw7MC6DzsAOlmkBf5a2vygroeBhmP
bHWnvdBXQ9/omt7YgqkiSc7Z7r7niSF/7LNu5INu8pTAyOWV8Y+zj+Zc/i7nEOm7
7JzFu3yXy2nA9NSI1ZdQoLcLNga8bvazSsfH7sEynDV9FcIwBPmUjzcET2urEBZU
wil7XquO3CDfxI2iujY9zmmb/6NTZXs2zX3sDNhc8CvUIuZS6mPjPkwdjvmSyGPQ
R4LX5Wxznr4MzQkFv1MaiVHBG2ZdgyUzUuXHauZijPeJwtCjtxgTjuyGppd4QZNc
VBKQy30KwkAWfOe4/wM67NvhfnY3iDT2jYFZL0FF2OKpMULxz82qPQrM/2m9ngut
Bh6tfDLBul6j7TRlXaH6WO6uz6CFeZ2jIzTza288lKr/gDOxt3ovsOpQ9jrpsDGx
wifcTeT/576KBek9XEKz7LqRFlb4dAtctAer0QmRn3H/EuWu2OBTlcDyGClI6XkG
lRMl6TDOj2rGDCVpMsv0I7sGcEYKjtzO38InDEugA0AGipvcJlFXXl8UwWTQznVx
jHIWpl0j9y5C6rq6C/vA
=MXlY
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
