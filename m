Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaKGMNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:13:38 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46793 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaKGMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:13:31 -0500
Date: Fri, 7 Nov 2014 13:13:25 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Subject: Re: [PATCH] drm/panel: update innolux n116bge timings
Message-ID: <20141107121322.GA11084@ulmo.nvidia.com>
References: <1409626606-15225-1-git-send-email-djkurtz@chromium.org>
 <20140922083929.GG1470@ulmo>
 <CAGS+omBFQi2BokDCV8DpRYwKs7DsGWKfxtDu8+7zJfKatL0SeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <CAGS+omBFQi2BokDCV8DpRYwKs7DsGWKfxtDu8+7zJfKatL0SeA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2014 at 06:12:41PM +0800, Daniel Kurtz wrote:
> On Mon, Sep 22, 2014 at 4:39 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> >
> > On Tue, Sep 02, 2014 at 10:56:46AM +0800, Daniel Kurtz wrote:
> > > There are several different models of N116BGE.  According to the comm=
it
> > > that added innolux_n116bge_mode [0], this N116BGE is for the eDP vari=
ety.
> > >
> > > [0] commit 0a2288c06aab73c966e82045c8f20b0e713baf2a
> > >  Author: Thierry Reding <treding@nvidia.com>
> > >  Date:   Thu Jul 3 14:02:59 2014 +0200
> > >
> > >    drm/panel: simple: Add Innolux N116BGE panel support
> > >
> > > The clock and htotal values from add by that patch are out of spec ac=
cording to
> > > the datasheets I have seen for the eDP N116BGE (-EA2 and -EB2).
> >
> > Does out of spec imply that these timings aren't working for you?
>=20
> No, I didn't even try with your values, actually.
> Out of spec just means that the numbers do not fall between Min and
> Max on the datasheet:
>=20
> 72.6 <=3D DCLK <=3D 80.24 vs. 71
> 1506 <=3D htotal <=3D 1716 vs. 1500
>=20
> > > This patch changes the values to the "Typ" values on the datasheet.
> >
> > The original patch was based on -E42 of the datasheet. But I can run
> > some tests to see if the timings in this patch work on the panel that I
> > have. If so I guess the easiest would be to apply this.
>=20
> Thanks!

Took me a while longer to test this than I had expected. Turns out the
Tegra132 Norrin board that I have works with the timings you provide in
this patch too, so I'm going to apply this patch.

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUXLdiAAoJEN0jrNd/PrOh28gP/2zNeEtm+g+V6GPRTc6GaQrO
q8hRSUlmpz3aKdoFl3+dYAJLbhKYsXEx8ye8q3Q6ag6jDHQrcrLmNsiXYy4OV3xV
hYW4EA9sJ6RX4n9AV0dacFF4E8DRB2mcGIYuhxNc8dmqWvwmgRuFdqIALnrk8K4d
97TscTDCghwTRC9qVzxCgCTYUvRezNrAeMh7LLfHywlIs6T5LvpLmjZ9f3p11Wts
CpkuphdkHVAFkzg/OnHDrKoc4x6XPNQbOVb00qP5yrzaMA2ZGzxF29Rt2qgr4O0J
zU/fX2Ob0JKAvCzKPd4hIWGn+bxQduQvNPCSnBh1vegPKHdpY+HHx4VbMDnJ8/sU
Nml73AL8Vy/Lz9sHLOexiPjVbzCFESq4t/qg+d0zpJvrbvjDWfSUOamSuKk7Zcmx
9cjwg+a52JB0cWfxxGc3+IGrPH87vOIsSO/93gA9Rny3HXOrYQtcJlBzekM0K3ZB
+Y2DNT6n+AukRmDsH/6D1/7AlysK+L4Byxe2Iqa2Xv8DnyTUzXaUX7EcqY7xCkYR
kpJdYcWJZc0VG3fD2inruP5lR4CjCCTUkcFhGwsoPz03h44XXf//wQhKnCiSjcWT
frmXZy/G5JbIHJyh5gR5tnUIYT9FZcTmulqFuIeRWA6dFvH6taawqnpcHI/UGJwC
jHQaId8GmI7yhHPIMuDU
=QPk0
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
