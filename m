Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3FRJwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:52:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43407 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab3FRJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:52:40 -0400
Date: Tue, 18 Jun 2013 12:50:41 +0300
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
Subject: Re: [PATCH v7 2/9] usb: phy: omap-usb2: use the new generic PHY
 framework
Message-ID: <20130618095040.GZ5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-3-git-send-email-kishon@ti.com>
 <20130618094058.GQ5461@arwen.pp.htv.fi>
 <51C02D0F.6010302@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/cFG30PKHi9lwv6o"
Content-Disposition: inline
In-Reply-To: <51C02D0F.6010302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/cFG30PKHi9lwv6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 03:19:03PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Tuesday 18 June 2013 03:10 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Thu, Jun 13, 2013 at 02:13:52PM +0530, Kishon Vijay Abraham I wrote:
> >>@@ -159,6 +191,12 @@ static int omap_usb2_probe(struct platform_device =
*pdev)
> >>  	otg->start_srp		=3D omap_usb_start_srp;
> >>  	otg->phy		=3D &phy->phy;
> >>
> >>+	pm_runtime_enable(phy->dev);
> >
> >enabling pm_runtime here has the potential to cause a real big problem.
> >How have you tested this patch ?
>=20
> performed boot and enumeration testing. What issue do you expect here?

hint: look at drvdata usage around the driver. Where is it initialized ?
Where is it used ?

--=20
balbi

--/cFG30PKHi9lwv6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwC1wAAoJEIaOsuA1yqRE9j4P/ioqJ0WhqUUxwPRAOkJ8VHhQ
rGNbxNNIvqd1KK0uY/VWd0wVv8NYKCrVI7UFEBBWC5jiMunC0VU4aNbsd16hbzF7
8uUYLQkPuUmw8bKzyggRT1/vMq/xkwzWlqOrzsXyr99epY+EXuG0QrY+pO0nqha/
WRyBZdRSu/pEBQ6R+AA0/06UrRhx09TBIS7YNWg86P/rACf7J7KJ7RHzkt8ax1NC
WF7y4ZSSvq79SSmn5XEM9SNRs68wgBdDk0qDaNOy3g6A6v104eTuxvKjFNv7VguG
Kug1KQFKmO/UWjCwFHK2M5SWEQLqfKMf3BnLi5NvMZZzPwAHO9Kkvl7L1WwJRS2M
NGTD8Fk85mKEi+AtIIoIrF//Anmzq0skzR4gZAeCpJ5OpH/pwxWjcBDjzZGdzupp
RldW+ckxzBg4NHfwTD1qCUN8X5G0QxYOs9H033L7U0PZntk50U73onNDbjT4LWiZ
zaG0x9wt80t/7mavP2tPzP/bGm1/XImsN50sHCJYMEK1y5M/1qbxOKWPOGGaB+yU
to+EI1T3vkhMQK1oFr2otQL60G2UXcYd0wcscL16YUfveRAFBH9OvdqcQBXzbzfd
t9TRLwmmizXDzjAw+sF+jOZDIKpEkg4okejELmPLdi8avNdrnPUpmXUxaxsGYK9R
jjv8Z0OWLHYsPaUDwAn5
=xS/h
-----END PGP SIGNATURE-----

--/cFG30PKHi9lwv6o--
