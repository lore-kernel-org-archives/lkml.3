Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3GLJhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:37:47 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49199 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3GLJhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:37:24 -0400
Date: Fri, 12 Jul 2013 11:37:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Rutland <Mark.Rutland@arm.com>, nicolas.pitre@linaro.org
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130712093720.GE24370@lukather>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
 <20130629193819.GD3353@n2100.arm.linux.org.uk>
 <20130630094846.GA27559@e102568-lin.cambridge.arm.com>
 <20130705101946.GA5584@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <20130705101946.GA5584@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lorenzo,

On Fri, Jul 05, 2013 at 11:19:46AM +0100, Lorenzo Pieralisi wrote:
> On Sun, Jun 30, 2013 at 10:48:46AM +0100, Lorenzo Pieralisi wrote:
> > On Sat, Jun 29, 2013 at 08:38:19PM +0100, Russell King - ARM Linux wrot=
e:
> > > On Fri, Jun 28, 2013 at 01:05:42PM -0700, Olof Johansson wrote:
> > > > On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> > > > <maxime.ripard@free-electrons.com> wrote:
> > > > > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> > > > >> The patch above should already be queued in next/dt right ?
> > > > >
> > > > > Indeed.
> > > > >
> > > > > Then why the latest patch of your patchset got in 3.10, while the
> > > > > patches actually fixing the DT it would have impacted were delaye=
d to
> > > > > 3.11?
> > > > >
> > > > > (And why was it merged so late in the development cycle?)
> > > >=20
> > > > This. So now we have to scramble because some device trees will
> > > > produce warnings at boot.
> > > >=20
> > > > Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> > > > re-introduce it for 3.11). Do you have a preference?
> > >=20
> > > Sorry but I really don't understand what all the fuss in this thread
> > > is about.
> > >=20
> > > This thread seems to be saying that two development patches were
> > > merged, which were 7762/1 and 7763/1, and that 7764/1 is a fix?
> > > Are you sure about that, because that's not how they're described,
> > > and not how they look either.
> >=20
> > As Olof's warning downgrade is being merged (thanks for that and apolog=
ies for
> > failing to explain patches dependencies properly and stable related iss=
ues),
> > 7764/1 won't apply cleanly anymore. Can you please drop it from the pat=
ch
> > system, I will update it and test it first thing tomorrow and send a
> > final version to the patch system.
>=20
> Patch 7779/1, replacing 7764/1 is in the patch system now, and is ready
> to get merged.
>=20
> Unfortunately cpu/cpus bindings documentation updates, following:
>=20
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/036735.ht=
ml
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-May/033779.html
>=20
> were not pulled in the kernel. This is an issue since this means that
> we still have no reference in the kernel or wherever it has to be, to
> the final cpus/cpu bindings for ARM and ARM64 provided in the pull
> request link above (that has been reviewed to death and acknowledged).
>=20
> It is a significant overhaul of cpu/cpus bindings standard for ARM/ARM64,
> covering all CPUs harking back to arm926 and beyond, and should be final.
>=20
> dts updates following that standard have already been pulled into 3.11
> through arm-soc.
>=20
> IMHO the bindings contained in pull request above must be merged in the
> kernel asap, I would like to ask you please what should I do to get them =
in
> please. If we want to move bindings documentation elsewhere let's do it,
> as long as there is a published standard I am happy and will stop annoying
> you with this stuff.

Just to be clear, I had no problems with the patches themselves, but
just the way it was merged.

That being said, I think every DTS patch you did should be merged by
now, only the second patch of this serie for the A10S hasn't.

Arnd, Olof, could you just apply the patch 2 for a 3.11-rc*? It's the
only rc patch for the sunxi platform for now, so I don't think a pull
request would be worth it, but I can send one anyway if you prefer.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR385QAAoJEBx+YmzsjxAgPS8QAJ8lcj08QZBDAORWa64vAMK1
WlM1vDA7JOH2mrbs39pRf0sMjRbOmuI1Dc06u46Wm4hcXJSStoVBtKd6N2+px1gA
bUiic30BY8KLS8RmN+WB8zwJ9xt0dBurm3M5c7NGNE1Fmac5iUWdDdaNu8mUJr8X
+/orKY80FqoPw47W+S8/sekx87nQbhEDvXp4Wg2MzgpkUf9OmrHj1fsorzfzOe62
wReyjgXmawt4omAxMBhdZUgE6DfEHQ8oNp16ckN+LbX3veTSFI5XzunbS/5fRJjB
BtiW9G8Dwco2YHGBAOAdTwaTY6DY9Otq3JniTo0tHCfKM9oMo8/oVOTKQtm+CWCr
sK1VxYBTT/jUnhFB2sZcbuUm48VIigxMrjleSmmQXxi1FuywqFaqJhu/T+8CB4Zy
GWszkHOQZ4Aw8JyjYRQt79hSND19JkUVnnEDfHkCtWQJzeTHfp0eB6f0t7akI1BV
oMMUvCmwsw+Oox2xlqK+VfwbI0FYEk8ck0vQwxvRQONM8p5LHI0eD/ebS9ijc8UU
VAhHQYswrgyMVBoLT9oKoUihdbbiU9KRycStWr7c+JH+Z9IOjvecVT7JHUf3Sicw
5IpxQAJvPFtNpYppa/xnJzGAHcGC1X+o+SFAMOWm8zKdKvUzHdRllRroZ/LWaJtK
MPkbgMxeuufWdJ+LFkff
=nOPy
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
