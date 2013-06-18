Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3FRK32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:29:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56658 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3FRK30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:29:26 -0400
Date: Tue, 18 Jun 2013 13:27:25 +0300
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
Message-ID: <20130618102725.GB7843@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-6-git-send-email-kishon@ti.com>
 <20130618094438.GT5461@arwen.pp.htv.fi>
 <51C030B4.5070707@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <51C030B4.5070707@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 03:34:36PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 18 June 2013 03:14 PM, Felipe Balbi wrote:
> >On Thu, Jun 13, 2013 at 02:13:55PM +0530, Kishon Vijay Abraham I wrote:
> >>In order for controllers to get PHY in case of non dt boot, the phy
> >>binding information (phy device name) should be added in the platform
> >>data of the controller.
> >>
> >>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >
> >I would rather not pass strings around, any other way to handle this ?
> >Why do you need to pass this string ?
>=20
> Our old way of binding the controller and the phy using device name
> started creating problems after the devices are created using
> PLATFORM_DEVID_AUTO. Infact non-dt boot is broken in mainline for
> OMAP3 platforms for which I have posted a RFC series
> http://www.serverphorums.com/read.php?12,708632 which also uses
> strings.
> I'm not sure of any other way to deal with this.

have you checked how other frameworks handle it ? Regulator has some
sort of binding in board-files, but I guess it passes the regulator
name?

--=20
balbi

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwDYMAAoJEIaOsuA1yqREUX4P/3OuItDq1QeDBeuFjqAIQR+8
O5h8zEMhbPGeHFY/ieRkQ66RbD60nEJNqn46EpBP/KI0bIwS8tK0T38nAhS//Dl4
/wXfCfVbDCnglIQCpdrnxnZEN0854rqDA7Gsc3CI8oEro9dBnWh1oOYjWZiBJrKX
SizirgLGvFmn1SMMTZGe+qJT/DyGWmGcd86fSsiu1amRFGXjP82Ov1HNxa4F4VvE
umzn8VDn4J08wER0F2LyIlUfXkEKxAY/DK72RewiyY8EJUXAnV0GUliGqK7hfuto
KAUi/17ZSKp80ec9LEqiredvwwQyoWvvg8TjcpMJz1UYN4Yzbl6ehiwYE4Tr423k
3fDWaH1gagwa+0Vd0HQeLCaHByR/W3utBWcc6AYe5sWsQmzYNqiB1Z1DodrldGks
m2vJn2mY13PH7emSN1AiIpy1IH9B9wZbeYfJeD3v9T8GCGhPO+N5SREkdNSqEAXB
LIPu3etHFqnIMtlhWHbhKCNfX314mP6g45rGMJSWsSyr+cokI7Sk06xp1WWJaYt7
qW3zszUTeQfuODKbxnVQjmHlDutkaMGyI3nS2wud+j1LamHnaZhCBDfJePKfGWdE
e15xd4i9PTVbSSNZy3+S06I3SS0FdXOBlx/W/5cx+cu6XOEDD+702CRCXCXVQksg
3+Ug6SAoVp+U69YFJ58q
=AoQU
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
