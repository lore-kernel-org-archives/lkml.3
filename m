Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755Ab3DCPoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:44:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37469 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761060Ab3DCPoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:44:23 -0400
Date: Wed, 3 Apr 2013 18:44:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Fabio Baltieri <fabio.baltieri@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 0/3] check regulator_enable() return value
Message-ID: <20130403154405.GC19093@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
 <20130403140622.GI14680@arwen.pp.htv.fi>
 <20130403142238.GB10021@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <20130403142238.GB10021@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 07:22:38AM -0700, Greg KH wrote:
> On Wed, Apr 03, 2013 at 05:06:22PM +0300, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Apr 03, 2013 at 04:02:24PM +0200, Fabio Baltieri wrote:
> > > While testing your 'next' branch merged with today's next I got some =
new
> > > warnings, caused by a recently introduced __must_check in:
> > >=20
> > > c8801a8 regulator: core: Mark all get and enable calls as __must_check
> > >=20
> > > These patches introduces a check for regulator_enable() return value =
in
> > > all three affected USB phy drivers, and issue a dev_err() in case it
> > > fails.
> > >=20
> > > TWL4030 and TWL6030 patches has been build-tested only.
> >=20
> > Sorry but I can't change my tree anymore, we can send these during
> > v3.10-rc.
>=20
> Really?  You are going to send me a tree that adds build warnings?
>=20
> Please don't.

alright, I'll merge these in.

--=20
balbi

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXE5FAAoJEIaOsuA1yqREiPYQAIJY6hHTeA/UG3afUNnDWwP5
s60sqzXYA8GHjyGoRqjVdCNkVtrP0TwUdCs4wfr7STXTixRujIDxi5yqDv1zy7ed
EcHAKGbaIIfxI6asZeeq4AxWFAcLz3CHCAftm61PhPrX+P+Iu4StJ8WzHM1/SxTe
J+Gdyl5g7ZxDD8WwRDwX7MgMimcMghUXCZaOiFE/lVqhIQOv2lNgLmPBLXi9Jcxb
npW92t0lyheykahh9sp78cgBo+smmelBxgADr8y4Kq/weB1xT9+pkBWj4MMvssxw
WQVn5gbKVLmGUKN0nC6gy2OJZ6LpZK6BsLTStn3UhP+9Zj55Bvr6dPvBK/JbZpPJ
tggG0yDrqlmeXOhs1BpS4VYaqKPm432WZboq2bIZ3p/M9mqHqdfXZPc1ll3VzFR/
trUD0WdE2F0YEqxtz0Mdh9elYc6cCtWoPqf0zM4c0mFVdwENRW++4YtsZIPhz0em
gO07Rprs+I3MembXDTkvN62M86c/uRG8XSWmtuI+pE4CZE2kbocG0nNvr7jVRrOU
UnR3XIG1Wo6Dm5OflKrsCGml0sKFiOhqvKdji6qxm4/3SsCvajo7430wMY5T21sZ
LqbjRz26nC1xBwbEvioHjITtXCh5PD8agKXm08/kRNhezG0oLuREMsAm4gDHUOSC
iyi6Ym7JaElav5eJlOTC
=6s49
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
