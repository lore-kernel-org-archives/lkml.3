Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab3GWRg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:36:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55334 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab3GWRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:36:26 -0400
Date: Tue, 23 Jul 2013 18:34:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <20130723173454.GK9858@sirena.org.uk>
References: <3419798.aorxYv8pdo@flatron>
 <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i5oaXLJ4GqfCAla0"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i5oaXLJ4GqfCAla0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 10:37:05AM -0400, Alan Stern wrote:
> On Tue, 23 Jul 2013, Tomasz Figa wrote:

> > > > Okay.  Are PHYs _always_ platform devices?

> > > They can be i2c, spi or any other device types as well.

> In those other cases, presumably there is no platform data associated
> with the PHY since it isn't a platform device.  Then how does the
> kernel know which controller is attached to the PHY?  Is this spelled
> out in platform data associated with the PHY's i2c/spi/whatever parent?

Platform data is nothing to do with the platform bus - it's board
specific data (ie, data for the platform) and can be done with any
device.

--i5oaXLJ4GqfCAla0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7r67AAoJELSic+t+oim9mQgP/jtUcLJCh8K5fwvGamn4opPT
Lmfss8MxAGPhgblBb24+aRD7dKntVOSYIQKc51TUXDfzjyUWqCfEo6U46ej6lfkD
kiHlIHfy6YjqIeMmI08dX/OyzgJf9wg/Btf8f3niSmEaQ6GiyuOy+ok3VLJqoIae
lTa+q8mGrWIqHb0+sP0rolztvR4dqHWg8DseVc6mH21kR+RTexwlJcBSJJcL8xmA
IrUbMzt4/35JMeLrgf43T0cuKrP59hT+9Cl4oEVx92We+9Jrc1b4o2LyhlxyAkM/
X7B86hl3ExmvYnPgHMR0N4PiRgsG1XIgFAPHrQQRvfieLm3irgLUnTc9RMIdzpS7
jsgBzR8x14b33ZtGJ8fo9WMlfO9N3ELrLQY4a6g39DPtqxCzyYMbCy5+HVNbUxvP
nnC9V/2Mi01G9AFK1sOocgSZjKjvXa3W5Dgc8KNXIa0d7M8Gy1j/ToGFdDT2Rk9F
f5OjxvRZv8mSffV/vp3GbNbjOhfzB3jRQp3ltmh+ayhnZmfmraOCMiQvfFuacPaC
/QqPWfXLBO+S8iUYsxY5SqhbgP7qbOcfPFzMy6YtDuuNKvNCLbMubhW8fgDX64pt
/nVnmWZa48yb0dCJj0rY/lNNWvFRjb2D3YEhoSxSg7i0oZk8lPO0Ivid3VCZ3AXt
It00egc7+yTUssZUPYJW
=NMIj
-----END PGP SIGNATURE-----

--i5oaXLJ4GqfCAla0--
