Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3FYPVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:21:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60994 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3FYPVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:21:41 -0400
Date: Tue, 25 Jun 2013 18:20:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>, <balajitk@ti.com>,
        <george.cherian@ti.com>
Subject: Re: [PATCH v8 7/8] usb: phy: omap-usb2: remove *set_suspend*
 callback from omap-usb2
Message-ID: <20130625152044.GL21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372139926-3719-1-git-send-email-kishon@ti.com>
 <1372139926-3719-8-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qo7zVO9a9OQ5oQtr"
Content-Disposition: inline
In-Reply-To: <1372139926-3719-8-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qo7zVO9a9OQ5oQtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 11:28:45AM +0530, Kishon Vijay Abraham I wrote:
> Now that omap-usb2 is adapted to the new generic PHY framework,
> *set_suspend* ops can be removed from omap-usb2 driver.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--qo7zVO9a9OQ5oQtr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybVMAAoJEIaOsuA1yqREH6AQAJJX/sIADvIF9X+jt20tCw3V
2Jan7WMJSQb2ZvV85w438A82HeJEufC5vf2CxpqMNJ+cdFHj3S3J/pp6pAd/GCdr
rL52849y2rGEZDh20vHbul06/3h7UsVg6KFzHGMRiltO+BkclRXsTwcjX8iwoYCD
F04FSpEnaXELxy4I3KKcObewLL5TihXuNrJMLHB4p49zRDE+SwiVmo7xMIX8iWlI
UGapJ+dOkA1Zp1pLS4uJVboCmksxJ7b9nSxMwrfm5y/k9AZ7kUpqx2ynAo/M1bJm
UOz2H2qOisSH5AT/ulG8guApg2iRw/MpvO6LJJHVE3ibmH66jOfom3Y1vxWRiR10
yAguxp75HZKJqCnlWvWcCpHDkGTuZfXEZDCDIbpr0r5bz45HBRyeowysirlK4IcL
BPj8HknHfheLYZYqfGA3kJY80K6xAXom3GTnTIl/ezvsQohi/R+ZvJvjne7vfntH
zO7vFbtGn7nKF63lQPUyi4JQNICNqbsD0mkMEqaCdZP+sfOleUHoG15Uu3ZY7ll0
iCMg/hE3Z9An2J4Z/P+mGfW7op2vankcZSgxpXAuzZnySIXQBCQkK+YBjOq5Nvvq
vMhwE4bZ3FiyZTgJwMVSbrR3tt5H+plj34ag4ukrs21Cy72L8EGxAH7oyLW93eYA
VA0gwq2FAlNHTeGx5LBW
=OGPh
-----END PGP SIGNATURE-----

--qo7zVO9a9OQ5oQtr--
