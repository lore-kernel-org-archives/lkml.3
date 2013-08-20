Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3HTOav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:30:51 -0400
Received: from sauhun.de ([89.238.76.85]:39952 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3HTOat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:30:49 -0400
Date: Tue, 20 Aug 2013 16:30:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jerry Snitselaar <jerry.snitselaar@oracle.com>
Subject: Re: [PATCH] i2c: move of helpers into the core
Message-ID: <20130820143043.GA2993@katana>
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de>
 <3792014.HtzPVmLjnf@vostro.rjw.lan>
 <5212A293.2030903@wwwdotorg.org>
 <3721030.UJAkTdQrEC@vostro.rjw.lan>
 <20130820092813.GW4898@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20130820092813.GW4898@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2013 at 12:28:13PM +0300, Mika Westerberg wrote:
> [Added Jerry as he found out a problem when acpi_i2c is being build as a
> module, this should solve it as well.]
>=20
> On Tue, Aug 20, 2013 at 01:25:27AM +0200, Rafael J. Wysocki wrote:
> > On Monday, August 19, 2013 04:56:19 PM Stephen Warren wrote:
> > > On 08/19/2013 05:04 PM, Rafael J. Wysocki wrote:
> > > > On Monday, August 19, 2013 03:19:18 PM Wolfram Sang wrote:
> > > >> I2C of helpers used to live in of_i2c.c but experience (from SPI) =
shows
> > > >> that it is much cleaner to have this in the core. This also remove=
s a
> > > >> circular dependency between the helpers and the core, and so we can
> > > >> finally register child nodes in the core instead of doing this man=
ually
> > > >> in each driver. So, fix the drivers and documentation, too.
> > > >=20
> > > > Perhaps we should do the analogous for ACPI then?
>=20
> Here is the ACPI version based on the current patch from Wolfram (there is
> a compile error because of missing dummy implementation of
> of_i2c_register_devices())
>=20
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> Subject: [PATCH] i2c: move ACPI helpers into the core
>=20
> This follows what has already been done for the DeviceTree helpers. Move
> the ACPI helpers from drivers/acpi/acpi_i2c.c to the I2C core and update
> documentation accordingly.
>=20
> This also solves a problem reported by Jerry Snitselaar that we can't bui=
ld
> the ACPI I2C helpers as a module.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Nice, one thing, though:

>  	/* create pre-declared device nodes */
>  	of_i2c_register_devices(adap);
> +	acpi_i2c_register_devices(adap);

I prefer the if (IS_ENABLED()) solution and will use this in my V2 as
well.


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSE32TAAoJEBQN5MwUoCm2EYAP/0dkhCPPhe1WQe8ruo9GZv/M
ie2yM4x2+IXNurZGc8JnxgtBH9D2I39ZEatRsBFJy6ISOCNqb5okdEMPmbAL37gk
iOUZH3KUqvlgaADNd/sQHH13xlZzi/0Rjb8695QhMGwSqljZFEoMw8BpvKc5wQtG
d1n4t56XDPjtYCbc5pStllBQiqKiu69eqjg7QjZVD+ZgUMbjTebuqsRcAxi0JLO7
Ieb69s4B4OlgYjgal4zyFX2v/JIJkI5f8KKxNr4DA6JzHR1lDKqmxMRlWGDCcr8O
JukFzU+f3hqfIcDaQcvfjdGflk3/ekroR9F2GPLFvPN4YRUb3SY5O65KoPzvfD4h
Ovu0GBANclvhwOd7kGvrL3/nON0X9Bb5aFCa5cb1JxzU1XrMNya+OuGZosCAxKs5
FEBQ67x+4BJgy5ITBnJgu7AC9E+JPMvtehGwPOHdTlkR7fxrC9Pf7ItA+vDaaNbx
G/HvV51hLhj2iI3rWwu31ijcX0T++IbtgHAL1UVHNuu64wQtrUOeVz7zPsGNf0BG
cw0ZQDr+QKbWlUeWqd0neMz4+zXFpUJoD+zHhrg8fX32c9dTVjYA/rAnIypk9aoU
1+9JnGj9y6gu1CNA7YC2vKGCBBCJqk6bFtbwRFuQZSfNkbKl92H5S/kt64QBvi4M
CxBJ76FB8B0RW9r8kUn7
=vcrl
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
