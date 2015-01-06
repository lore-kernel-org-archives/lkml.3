Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbbAFUaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:30:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60390 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbbAFUaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:30:19 -0500
Date: Tue, 6 Jan 2015 14:28:57 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, <pali.rohar@gmail.com>, <sre@debian.org>,
        <sre@ring0.de>, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <aaro.koskinen@iki.fi>, <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106202857.GB32308@saruman>
Reply-To: <balbi@ti.com>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <20150106175115.GA19487@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 06:51:15PM +0100, Pavel Machek wrote:
>=20
> On Tue 2015-01-06 11:25:45, Felipe Balbi wrote:
> > On Tue, Jan 06, 2015 at 06:04:33PM +0100, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > In 3.18, sound is nice and clear.
> > >=20
> > > In 3.19, sound is unusable. It produces nasty tone when it should be
> > > quiet, and there's at least as much noise as is sound.
> > >=20
> > > Unfortunately, list of mixers also changed (and there's cca 120
> > > settings), but a) it does not work with the old list and b) nothing I
> > > could figure out did make the sound usable. Some setting resulted in
> > > even more noise.
> > >=20
> > > Any idea what could have caused it?
> >=20
> > $ git bisect start
> > $ git bisect good v3.18
> > $ git bisect bad
> >=20
> > that'll help find what caused it.
>=20
> Telling someone to do hard and time consuming job that probably will
> not succeed, instead of actually providing help. Very very funny.

you're getting code for free, you're getting help for free. Not many
people have N900s lying around. Running a bisection is just politeness.

--=20
balbi

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrEWJAAoJEIaOsuA1yqRE33EP/2i+SwBCnH92zuaXrHTSEMJS
TwHOUN7CntSm7nrrYNLRr4wwp7zCtk5SRyXvEQpMEArzvdOJMNhLD7QriL032hIt
hl1mU4YI4Df/WnJHx3535cKV5r+UeCfGvZgNs8qeGp3QdzeH4ASFN6ttI+MKxAN0
ezgPdnqY2al50MyN+XH6haAsy6BA+BvWvM/I9vnvKgn7FiZ/1i2S49TDh3+jYk/s
459wbEG1/gb61HlldaXyy3Pbc31635S2UBs2jILv5iIvRxP1GsDHzyckV6X/raAz
stPty7OvD04CciXaQ7yOx6/EiRsKtD+L3Way+EEytsIJCB2msK1Lf02MX6E7w2K3
QLSfHfXR2aKDrLs30rI4bctzug4Wd8+3eVJ/jUsAf3MN63yDu6k+/QH0tn+O5PSO
bcVkckBfMMF+FCh15hFLw9TnOHymXh1ySJbGu2yCtQO/u/qb9pLmuwJ2kF6cghoZ
vQ7xiE2grs7Z2hafNBi4iy9ZKgykyHpaTVlTjWC+BuwLwLlZuq5KUg15z9vOl6Au
lrB0umD8iaIKpFeqot7o+3/8bp4z2RGhtkskhVNL7zk08Gin6nGTISsj25eSkbLA
QMQ/MFRyE2Sc2nP+QqNXPEYEk8BA8Hg73TZFwSUZyg9vqEz4x6xElFGumshwBqzU
5wnlFwU4xg0lXDXs2njU
=oPkR
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
