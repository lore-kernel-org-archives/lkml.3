Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaAaPtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:49:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54591 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbaAaPtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:49:03 -0500
Date: Fri, 31 Jan 2014 09:47:21 -0600
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <balbi@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
Message-ID: <20140131154721.GD20736@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
 <20140131151955.GB20736@saruman.home>
 <52EBC499.2070302@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <52EBC499.2070302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 10:43:21AM -0500, Santosh Shilimkar wrote:
> On Friday 31 January 2014 10:19 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Jan 31, 2014 at 03:20:26PM +0200, Grygorii Strashko wrote:
> >> The Keystone PM management layer has been implemented using PM bus for
> >> power management clocks. As result, most of Keystone drivers don't need
> >> to manage clocks directly. They just need to enable runtime PM and use=
 it
> >> to handle their PM state and clocks.
> >>
> >> Hence, remove clock management code and switch to use runtime PM.
> >>
> >> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >=20
> > quite a few weeks back I sent a series enabling runtime pm for all glue
> > layers. I'll use that version instead, sorry.
> >=20
> That should be fine but you need to drop clk_*() related code
> from that patch. I assume you will send refresh version of it then.

why ? it makes no difference if you enable twice and disable twice.

--=20
balbi

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS68WJAAoJEIaOsuA1yqRE7OsP/jtSjK+kGczxAb1XComjMdmk
H3RNtdQT6FBEcnPlayd7szf1T/WifmzXI191kVzGpwfxTaHa0t7lqRSRJGb3Hl7P
8WVdCSuXdsA6ii/0ntr6tK/cbUxLFl5VK9v794aOGU0EgDvTXY7kR3wmOyHGmGNu
xlImoxG7OMilljpeDfh+7WiWk4e6FgBbKfOKhHudmFTLqDz6ImdieWs+G6Hx0gTO
EgVZgR++pIL0Bbb5UOVA8aub5YZ+rxCXkGTqfI1b7gMJJZCSnNhr1Mo6+xHPeA6+
l495CrvKzy3CIomclhyGEwb7kV3xiU9OTA4uOXC/bHHdCNVVcx/8D8wSubPcQcZe
5eNZfbguTwpwXmeCMRAuwHIaQBIiZOLm1OpQcYlsHk16/+bmFh6IUJsyqeHNKNf5
61o2Sm5ziCXb0jXkQnNMwtHZCvkrK9c1WGnGtCl7ftqAHTCOuo5ANCwZrV4lA600
Lm+DeK+Ok+W1vnoLytfGqzFXVbT9FDBvefxMxmdRweQBQwYGzMTEWdnDNcPFDGAh
sFXBZ77XrbuB2zJVnjcNi4yp83oBNSnrou0IQTZ2TcGGjeAxdjZNTVYuhLl6LsqD
NG3doq2OGPWE1X9nv8LnuW7Z0WECOMGUUfvdVMCImOHKyFIiJErkeSQTj7JclAJr
PRjwS2Y2rx5zCZCZM0B8
=HMI8
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
