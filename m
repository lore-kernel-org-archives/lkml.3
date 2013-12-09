Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460Ab3LIVBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:01:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40929 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab3LIVBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:01:49 -0500
Date: Mon, 9 Dec 2013 15:01:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131209210101.GC29143@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
 <20131209041152.GC20608@saruman.home>
 <20131209194032.GC28441@saruman.home>
 <20131210074330.7875f55f1a0e25bd4c2acf0d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Nae48J/T25AfBN4"
Content-Disposition: inline
In-Reply-To: <20131210074330.7875f55f1a0e25bd4c2acf0d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 07:43:30AM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> On Mon, 9 Dec 2013 13:40:32 -0600 Felipe Balbi <balbi@ti.com> wrote:
> >
> > On Sun, Dec 08, 2013 at 10:11:52PM -0600, Felipe Balbi wrote:
> > > On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> > > >=20
> > > > After merging the usb-gadget tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > >=20
> > > > drivers/built-in.o: In function `otg_set_state':
> > > > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> > > >=20
> > > > CONFIG_USB is 'm' in this build.
> > > >=20
> > > > I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb:=
 phy:
> > > > Add OTG FSM configuration option")?
> > > >=20
> > > > I have used the usb-gadget tree from next-20131206 for today.
> > >=20
> > > I see what caused it, will fix it up with a patch which should probab=
ly
> > > be backported a few kernels back. Thanks for letting me know.
> >=20
> > Do you still have the .config which caused that build error ? I couldn't
> > reproduce with CONFIG_USB=3Dm && CONFIG_USB_OTG=3Dy.
>=20
> See above, it was just an x86_64 allmodconfig build.

cool, building that on my end.

--=20
balbi

--6Nae48J/T25AfBN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpi+NAAoJEIaOsuA1yqREpXgQAIZg9IvaqsC9HdSfedbqojCU
w9Jw1VPyx8djpNC5x58B6s4oznkmRg+uENRhXJATAKZxIZEdLzB2Bo2lTVtZkAtS
/Im0d3kGYmB3x2WliE6U04HL9s7XElIrvsGB853vXk7bd4kXUCpXh18+tvnRIASk
pfkfFA5At8niW37+g7TSfZdvso0GBhuyD9Dns3mL8MLIXNP7VEZunYHFUcX4YYz7
1WnIcLShI1/iNX/430SCR9afF5JUD5Y4eRU8r3OBvbwpVZt8dowlAIhvknPdeD1S
oogUjpMn6kfIVDBW+zbUuZBxobPLrVT1DETZOzZwNSnLsYWPu2B9NnJch28tEGRS
bkb+BCJxtPiDW4eo2v8223J+3MAYygj6MGAMo/T2hV21HF8ZNQ/S5FmmHtDK+T5q
5G98MIy2IE/kkKFuxjQYQCD0wNQpqtowZ5lNu4SQ53Il/uzdv+u7/ueLJQWixTgp
wzSG4/zr0ITmDX58+9Yt+gwlmugenXKKJvgMo26p0ukVWJCSk+8KC/eo4dCUDbIg
wHsQ7WoPOtuXBoo/cgqy0TKOwf5LHQzzonYUMCqSQiD0Nho4C7LrPrcsUGHIDX7e
xhLt5EchgtmpzqR8RYXj3v9rYg3zbkgF3TdXF1ZpuKkmZlHBsatTxXy2YKeXbdpS
w/yAGIv++O3vAP35HUdB
=un+E
-----END PGP SIGNATURE-----

--6Nae48J/T25AfBN4--
