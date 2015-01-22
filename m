Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbbAVUv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:51:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46461 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbAVUv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:51:26 -0500
Date: Thu, 22 Jan 2015 14:51:24 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150122205124.GG22288@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
 <20150121091749.GB22716@kuha.fi.intel.com>
 <20150121113958.GC22716@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
Content-Disposition: inline
In-Reply-To: <20150121113958.GC22716@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 01:39:58PM +0200, Heikki Krogerus wrote:
> Hi,
>=20
> On Wed, Jan 21, 2015 at 11:17:49AM +0200, Heikki Krogerus wrote:
> > On Tue, Jan 20, 2015 at 09:45:39AM -0600, Felipe Balbi wrote:
> > > > diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tusb121=
0.c
> > > > new file mode 100644
> > > > index 0000000..ac77f98
> > > > --- /dev/null
> > > > +++ b/drivers/phy/ulpi/tusb1210.c
> > >=20
> > > do you really need this extra ulpi directory ?
> > >=20
> > > I wonder if phy-tusb1210.c as a name would be enough.
> >=20
> > IMO grouping the ULPI PHY drivers and other ULPI bus code into
> > separate folder from the start is the right thing to do.
>=20
> A correction to this comment. I probable don't need this folder. Like
> you said, phy-tusb1210.c should be enough..
>=20
> <snip>
>=20
> > > In fact, we might decide to add an entire ULPI bus, eventually, though
> > > I'm still considering if there's any benefit to that.
> >=20
> > I don't think I understand this comment? ULPI bus is what I'm
> > introducing in this set (the first patch in it)?
>=20
> ..I talked with Alex about this :). So I think the bus belongs under
> drivers/usb/core/ instead of driver/phy/. It's not really tied to the
> Generic PHY framework in any way, but ULPI is of course USB specific.

right, maybe drivers/usb/ulpi or maybe drivers/ulpi, and have
phy-tusb1201 register under that ulpi_bus_type instead of
platform_bus_type, but still use drivers/phy to register itself a phy
provider ;-)

--=20
balbi

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwWLLAAoJEIaOsuA1yqRExy8QAIwnhOW7rZXLpQJUxhylDZCn
3U82iQim6qd0MYqtqdeL8KhprpKIyOwKa0268f/7yVap7SvHN8LWLPpjctbvgwEQ
XN/qTn87Iij/pyYi0M7TNXp4SjfQA8Q+ItsBXIKdngmrhKboY4Xv9SBGQsHDcldV
jyu21JKcytP251PMBe7EQbfiLpjCLfAHOmJ/I38D6hFKft+l3pFzkJEn5OOoyVgL
t0BMe6znrFYFY+FjKHm6hnz+88+5XKrsGMkmjqTGDuU5dqzvBuLV0a2KMCuEQTVV
kt4GZktZ6kr1ZnHDhtRQ8L+dzDAzXqHWofRxUhGJg+7GHgAS+E4+u4HIfbjWXywk
Eb8Up0OY2mwWeHtoyFi10sXGb4j5s/xHZrkFScZF9LBXkXG2fXBjnGoKVEQJe+Tv
mz+LH2lsKr6Tpds9RK9jCAScqdumLew6c3FU6QrJw0Utpp5spsOkXb7nGKmt4N4o
9UFCV2mbiLoksnY8qrUHMm4Vr5sgkDjNEpaEKW/MRHWiTFF63UHbvFDZqCQkcpVn
L1anh0V1j2txbqwW69KkY155vnCdvq3O8vAPnxAd02GvV0IUKqwXh4lDYLiq43AS
veme9bXydZr/0auGu/slCPQTqz6Er1jTNVSjF/19+sywxPTOn4ac4s4c1iiRJngh
8kE07dQ7XvZ8z0DeGheb
=jy9D
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
