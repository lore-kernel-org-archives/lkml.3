Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3FRMho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:37:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34334 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3FRMhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:37:42 -0400
Date: Tue, 18 Jun 2013 15:35:36 +0300
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
Message-ID: <20130618123536.GD8620@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-6-git-send-email-kishon@ti.com>
 <20130618094438.GT5461@arwen.pp.htv.fi>
 <51C030B4.5070707@ti.com>
 <20130618102725.GB7843@arwen.pp.htv.fi>
 <51C040E8.2050904@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <51C040E8.2050904@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 04:43:44PM +0530, Kishon Vijay Abraham I wrote:
> >On Tue, Jun 18, 2013 at 03:34:36PM +0530, Kishon Vijay Abraham I wrote:
> >>On Tuesday 18 June 2013 03:14 PM, Felipe Balbi wrote:
> >>>On Thu, Jun 13, 2013 at 02:13:55PM +0530, Kishon Vijay Abraham I wrote:
> >>>>In order for controllers to get PHY in case of non dt boot, the phy
> >>>>binding information (phy device name) should be added in the platform
> >>>>data of the controller.
> >>>>
> >>>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>
> >>>I would rather not pass strings around, any other way to handle this ?
> >>>Why do you need to pass this string ?
> >>
> >>Our old way of binding the controller and the phy using device name
> >>started creating problems after the devices are created using
> >>PLATFORM_DEVID_AUTO. Infact non-dt boot is broken in mainline for
> >>OMAP3 platforms for which I have posted a RFC series
> >>http://www.serverphorums.com/read.php?12,708632 which also uses
> >>strings.
> >>I'm not sure of any other way to deal with this.
> >
> >have you checked how other frameworks handle it ? Regulator has some
> >sort of binding in board-files, but I guess it passes the regulator
> >name?
>=20
> From whatever I could make of, regulator has 3 ways to get the
> regulator one of which is using the binding in board-files (but it
> also uses device name which could create the same problem that we are
> facing).
>=20
> 1.) from dt data
> 2.) from _supply_ name
> 3.) from binding in board file
>=20
> (referred regulator_dev_lookup() in regulator/core.c)

right, spot on. Which means we don't have a better, more elegant
solution now. Let's go ahead with this.

--=20
balbi

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwFQYAAoJEIaOsuA1yqRE9mIQAI2MqozlRuRD5dPS+8PB7X/n
szivthcudB8IORFZOcZcYungNvj8XALlJsDMpeP5GHMmNRHC2PCYXBrXSWgLFW0m
OVOZ1KjmpyoY9ufcR/M0T9AmaSCQ2TrVF92Ey7JL09CW9vH6/4DZiva7Nlc79wJQ
dltl8RWnltcDTOIKkzkkvwq9+cKequoiWk8j/sTK6EzYaXAb5XkegZIiRS+Taala
ZszOvqd94Wh64SJePeT95YwlZNT+yu7B1FWsNyJ10JLQju1ldJggzTEEzgYR0eSr
ljzMWJC10WHAGSNU5RqOpbYzBV9MQsDo3U91Azax08YkH8SHBxdPYcz91P2eoTF6
h1DMLKg2cOl4Fo2vF02aY5pikhH0JL3JUkTCCgpu9CGmZrQjWMiuEezBracp28rc
bd87cviLYFoN8AEju9LNgJDYwjJTBWcEmPuem4bkNqge6g0Qi9eovA5JolnTPBK3
SNTcT+6nZLSPlZ8kfl/Bstvc3/53j1aM3OBjp1RGJyOIS33dTF/uRnCW+mMaXblt
XT9WhIyTKjvA3kx8Y1T4BB/x/72+gPfVB1M1xBTLraU68stKJ/rCEHMLBHf20LkD
3olvxVPa/iNRYzDnSseUgL6bxpBWtXstIXaGx9h2QjP3SKXzN4i9lR2ORYg+xbbr
mUn/SY6GH/i1TsovMdcO
=lCNm
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
