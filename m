Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbbAWQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:16:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56240 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbbAWQQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:16:55 -0500
Date: Fri, 23 Jan 2015 10:16:51 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150123161651.GD8585@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
 <20150121091749.GB22716@kuha.fi.intel.com>
 <20150121113958.GC22716@kuha.fi.intel.com>
 <20150122205124.GG22288@saruman.tx.rr.com>
 <20150123082348.GC30522@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eheScQNz3K90DVRs"
Content-Disposition: inline
In-Reply-To: <20150123082348.GC30522@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 10:23:48AM +0200, Heikki Krogerus wrote:
> On Thu, Jan 22, 2015 at 02:51:24PM -0600, Felipe Balbi wrote:
> > On Wed, Jan 21, 2015 at 01:39:58PM +0200, Heikki Krogerus wrote:
> > > Hi,
> > >=20
> > > On Wed, Jan 21, 2015 at 11:17:49AM +0200, Heikki Krogerus wrote:
> > > > On Tue, Jan 20, 2015 at 09:45:39AM -0600, Felipe Balbi wrote:
> > > > > > diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tus=
b1210.c
> > > > > > new file mode 100644
> > > > > > index 0000000..ac77f98
> > > > > > --- /dev/null
> > > > > > +++ b/drivers/phy/ulpi/tusb1210.c
> > > > >=20
> > > > > do you really need this extra ulpi directory ?
> > > > >=20
> > > > > I wonder if phy-tusb1210.c as a name would be enough.
> > > >=20
> > > > IMO grouping the ULPI PHY drivers and other ULPI bus code into
> > > > separate folder from the start is the right thing to do.
> > >=20
> > > A correction to this comment. I probable don't need this folder. Like
> > > you said, phy-tusb1210.c should be enough..
> > >=20
> > > <snip>
> > >=20
> > > > > In fact, we might decide to add an entire ULPI bus, eventually, t=
hough
> > > > > I'm still considering if there's any benefit to that.
> > > >=20
> > > > I don't think I understand this comment? ULPI bus is what I'm
> > > > introducing in this set (the first patch in it)?
> > >=20
> > > ..I talked with Alex about this :). So I think the bus belongs under
> > > drivers/usb/core/ instead of driver/phy/. It's not really tied to the
> > > Generic PHY framework in any way, but ULPI is of course USB specific.
> >=20
> > right, maybe drivers/usb/ulpi or maybe drivers/ulpi, and have
> > phy-tusb1201 register under that ulpi_bus_type instead of
> > platform_bus_type, but still use drivers/phy to register itself a phy
> > provider ;-)
>=20
> So just for the record: This driver does not register under
> platform_bus_type bus but instead already under ulpi_bus_type.

hah! :-)

> I'll prepare new version out of these today and try to figure out
> proper place for the code (maybe drivers/usb/ulpi?).

drivers/phy is fine, it is a phy driver anyway... I just should've read
it to see there was a ulpi_bus_type :-)

--=20
balbi

--eheScQNz3K90DVRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwnPzAAoJEIaOsuA1yqREMSwP/jlVrhowTbpa8Jj7QTZHDHUi
6hovmP7BG3g0Iq+Cx210n3CqQ+vmYrGZsf5/8sPG6nuf5vizKuYWN6HU6SbVqINT
y748ilmG/lHGjv9YPDE31pKKxhHyOAh8Qdbi2CCtGvPZEucxLnI2Qi+Uv3SkHq95
4QwjcOaf2yYUzCu3e2Legs1NvxCCfkjISIJrT+DkAkIkMXFS1z9xQ1uKD4OeSsbS
JVBfhblYUXOAP82m3RVN6de5TYFz+LLXIDEkj+t1e28usDhandz1LC26Z37dfnJf
Lxg6fsIEbg0dXZaWgPFDguKC7KVvA+YO6iRTxz+lb7ijh/5r3Ao71T4zf3dTNix8
+RiWFLG6QKn6cfJDrGOEGbjAtJbpuJTCFs5LvLH76qnw8UbQmcZ0j6orPTKsptuk
HrueR/WVuZd5SLMVjI4F4ornbvKyWYj/8F8J07EAsggX5gWHUi1D2qmUX1W/NbEd
5Dlm+DAC6SR64TnI3/tu2J5J5KbpwGrYKIzIWM8CYy5y+DvqqhLlB7nr2oLrng8d
Y5XkG2hhNf2nBFnWK5yJ2okMoW3yHbVACdRIPWxS+yWR1wt+V8Nupnq+SYlgcpT5
gQPPEhG8fWqCsK5XKFmJRf5n/+ukPC9YJ8l3mb8/vBpEQQ70a3h/yBoPLk5ciIz/
38iEdqAQVI6oxDY8e1d8
=7oFu
-----END PGP SIGNATURE-----

--eheScQNz3K90DVRs--
