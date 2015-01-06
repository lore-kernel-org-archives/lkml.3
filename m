Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbbAFUzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:55:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45133 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbbAFUzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:55:35 -0500
Date: Tue, 6 Jan 2015 14:54:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, <pali.rohar@gmail.com>, <sre@debian.org>,
        <sre@ring0.de>, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <aaro.koskinen@iki.fi>, <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106205413.GF32308@saruman>
Reply-To: <balbi@ti.com>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4SyuGOnfnj3aJqJ"
Content-Disposition: inline
In-Reply-To: <20150106205000.GB13902@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H4SyuGOnfnj3aJqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 06, 2015 at 09:50:00PM +0100, Pavel Machek wrote:
> On Tue 2015-01-06 14:28:57, Felipe Balbi wrote:
> > On Tue, Jan 06, 2015 at 06:51:15PM +0100, Pavel Machek wrote:
> > >=20
> > > On Tue 2015-01-06 11:25:45, Felipe Balbi wrote:
> > > > On Tue, Jan 06, 2015 at 06:04:33PM +0100, Pavel Machek wrote:
> > > > > Hi!
> > > > >=20
> > > > > In 3.18, sound is nice and clear.
> > > > >=20
> > > > > In 3.19, sound is unusable. It produces nasty tone when it should=
 be
> > > > > quiet, and there's at least as much noise as is sound.
> > > > >=20
> > > > > Unfortunately, list of mixers also changed (and there's cca 120
> > > > > settings), but a) it does not work with the old list and b) nothi=
ng I
> > > > > could figure out did make the sound usable. Some setting resulted=
 in
> > > > > even more noise.
> > > > >=20
> > > > > Any idea what could have caused it?
> > > >=20
> > > > $ git bisect start
> > > > $ git bisect good v3.18
> > > > $ git bisect bad
> > > >=20
> > > > that'll help find what caused it.
> > >=20
> > > Telling someone to do hard and time consuming job that probably will
> > > not succeed, instead of actually providing help. Very very funny.
> >=20
> > you're getting code for free, you're getting help for free. Not many
> > people have N900s lying around. Running a bisection is just
> > politeness.
>=20
> Now you are speaking for yourself or for TI?

why bring my employer into the discussion ?

> Thanks for your very valuable help. I know how to do a bisection,
> thank you.

then please do it.

> PS: Unfortunately, N900 will not boot using nfsroot in 3.16+ at least,
> and boot from MMC card is broken and has been for quite some time.

Then how do you know it changed from v3.18 to v3.19-rc ? Certainly you
ran v3.18 on N900 to verify that audio quality was better with that
kernel. Use the very same method during bisection.

--=20
balbi

--H4SyuGOnfnj3aJqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrEt1AAoJEIaOsuA1yqRE0wcP/38DXPEpNZFv/tBPC3xbTcQW
vmvW7D3/5jsLURH7V0c6+d+flMypEDmr8tI0siDAS4/OJyRWilv9+ZsMz0/+fKrJ
ReYmoz+dzCJ48SG63hm0GxEw2TPwpY8KVMIY/2fZ1e0RUr6AXq5i0GtL99wf9DbE
vwxBPwuyilAQHWbXHz7XQCh4YhAP/Y8U2s6sJWIF5NyIHm2tMti5t3ElpGOO60PY
EFQezTASweE2T6+dIDE+uSMKfhn9OK+V9DciI2J0eHnQ3OIVcEQCS0KFbOiIm7c3
tFIn5md5x9jNi/PRt9vpFnL6NyTNx3IRUYSqSeJ+WG+dyiyB58zLpgod6+KFL4Y0
G2QZi8vc9uRTcujisr2mofmlj3mvfsKrOusXz+m/G3UKDIBGc4VZiYZZJqVPM8vn
sigqf1UQ2eIDn+R+nirfiZf+tV8if+JqFWDtS4ZENDepdpX1Hy2yNCfH+Wl0bLOt
dyjqV72RGYGvmlpII/5iDPjpe4Rvot39z9vDrfVDjnTo7NeJXJOqtaYY7MutW0hV
UV1UKzZfcZ0VMY4xeWH0rWtEBOXoURnGYAkHYLhEUwYf4jZWcC/MBVeU/FFgX7a9
daPjXEaqk4JJVJT2fyKmeez0PeSGO9ZCc88MlrxHo4I7FL5SsTF/0ZHj2oqtHyRk
1+/nxeTGwVUA67fghULw
=Ex4G
-----END PGP SIGNATURE-----

--H4SyuGOnfnj3aJqJ--
