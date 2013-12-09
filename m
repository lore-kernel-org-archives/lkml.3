Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab3LIVnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:43:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38681 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab3LIVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:42:59 -0500
Date: Mon, 9 Dec 2013 15:42:12 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131209214212.GD29143@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
 <20131209041152.GC20608@saruman.home>
 <20131209194032.GC28441@saruman.home>
 <20131210074330.7875f55f1a0e25bd4c2acf0d@canb.auug.org.au>
 <20131209210101.GC29143@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J4XPiPrVK1ev6Sgr"
Content-Disposition: inline
In-Reply-To: <20131209210101.GC29143@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J4XPiPrVK1ev6Sgr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 03:01:01PM -0600, Felipe Balbi wrote:
> On Tue, Dec 10, 2013 at 07:43:30AM +1100, Stephen Rothwell wrote:
> > Hi Felipe,
> >=20
> > On Mon, 9 Dec 2013 13:40:32 -0600 Felipe Balbi <balbi@ti.com> wrote:
> > >
> > > On Sun, Dec 08, 2013 at 10:11:52PM -0600, Felipe Balbi wrote:
> > > > On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> > > > >=20
> > > > > After merging the usb-gadget tree, today's linux-next build (x86_=
64
> > > > > allmodconfig) failed like this:
> > > > >=20
> > > > > drivers/built-in.o: In function `otg_set_state':
> > > > > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> > > > >=20
> > > > > CONFIG_USB is 'm' in this build.
> > > > >=20
> > > > > I am not sure what changed to cause this, maybe e1d2e31975e1 ("us=
b: phy:
> > > > > Add OTG FSM configuration option")?
> > > > >=20
> > > > > I have used the usb-gadget tree from next-20131206 for today.
> > > >=20
> > > > I see what caused it, will fix it up with a patch which should prob=
ably
> > > > be backported a few kernels back. Thanks for letting me know.
> > >=20
> > > Do you still have the .config which caused that build error ? I could=
n't
> > > reproduce with CONFIG_USB=3Dm && CONFIG_USB_OTG=3Dy.
> >=20
> > See above, it was just an x86_64 allmodconfig build.
>=20
> cool, building that on my end.

patch sent to linux-usb.

--=20
balbi

--J4XPiPrVK1ev6Sgr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpjk0AAoJEIaOsuA1yqRE8NwP/2wfofwEVG1sKqu6A9VCs+xw
OI7+K+w+Mt1a/IDVpsXYjzUQKIPBic7KVcz9IYt2mC8YPp2WnTM8hhTkvcGam3zV
16kKeHAoMAx8arqdsRzt27dmKfWzjAp+D6kbI7m9zLZ4912J4SmDUQtQN7BXqv/1
s5nEInYRKssr5M/BHKBtPCjSUoB78L7EBIA+2W3ZnLh0BBAfgFyYCEANbwZIWDWQ
7FFn9uU0wtyLwPKL7157c/KdcatiXDYhd0S6Vr0jq0xZ0ETmP5tq4mnS7lrqkt7n
ejVEK+Ko3fHWgp5pEubEu7qa+S5/PelO+E5iozrK56U/dAm4Kn7E3HG/6yCI7BXt
mlYRXjoY5/Hjmq84v9nfFGEDKP2o5gpCKSeqpSaBkrLG4NOhGsW0JhOL9xqw/Mjv
6+UlzR6G5SxIjmngXsGZsTXzNlLZOR0yKsUQtX3R42xwp+na2rBeWcw4isSkOIwF
B8fffXiqXxlrjnvNRrdeD3nH+g9MHi5zcXk3ZOazXG1BB2uiVipfAf3S9idCyqOB
st8MEr5YXR0wU0jrI/UIWW9EGnhqrzQzIcPmXJPYHNXlLVfLLR4khr9g9+sgcbpY
NMa0wYpHGKQmwRMHYNbKGcn8Yr2/iqLIU0mPWCjF4h8wti6geCuVKOVS4tHeGDt+
RLlmUZIWN2WsIN23VIlM
=nIN8
-----END PGP SIGNATURE-----

--J4XPiPrVK1ev6Sgr--
