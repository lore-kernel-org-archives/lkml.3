Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaKML1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:27:13 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58692 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaKML1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:27:10 -0500
Date: Thu, 13 Nov 2014 12:27:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        gregkh@linux-foundation.org
Subject: Re: [PATCH] ARM: dts: tegra: move serial aliases to per-board
Message-ID: <20141113112706.GC23422@ulmo>
References: <1415738970-7963-1-git-send-email-olof@lixom.net>
 <20141112122017.GC30821@ulmo.nvidia.com>
 <CAOesGMjmVJuaiFZf6msFtsGiQn6TOPatZ7V3p-KfaPqpXnrYmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <CAOesGMjmVJuaiFZf6msFtsGiQn6TOPatZ7V3p-KfaPqpXnrYmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 09:07:20AM -0800, Olof Johansson wrote:
> Hi Thierry,
>=20
>=20
>=20
> On Wed, Nov 12, 2014 at 4:20 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Tue, Nov 11, 2014 at 12:49:30PM -0800, Olof Johansson wrote:
> >> There are general changes pending to make the /aliases/serial* entries
> >> number the serial ports on the system. On tegra, so far the ports have=
 been
> >> just numbered dynamically as they are configured so that makes them ch=
ange.
> >>
> >> To avoid this, add specific aliases per board to keep the old numbers.=
 This
> >> allows us to change the numbering by default on future SoCs while keep=
ing the
> >> numbering on existing boards.
> >>
> >> Signed-off-by: Olof Johansson <olof@lixom.net>
> >> ---
> >>
> >> Stephen/Thierry/Alex, as noticed this week we really should try to get
> >> this in before the 3.19 merge window so that the global aliases change
> >> can happen there without regression.
> >>
> >> If you have more fixes queued up, feel free to add this to the next pu=
ll
> >> request. If not, a review and ack would be appreciated.
> >>
> >>  arch/arm/boot/dts/tegra114-dalmore.dts        |    1 +
> >>  arch/arm/boot/dts/tegra114-roth.dts           |    4 ++++
> >>  arch/arm/boot/dts/tegra114-tn7.dts            |    4 ++++
> >>  arch/arm/boot/dts/tegra114.dtsi               |    7 -------
> >>  arch/arm/boot/dts/tegra124-jetson-tk1.dts     |    1 +
> >>  arch/arm/boot/dts/tegra124-nyan-big.dts       |    1 +
> >>  arch/arm/boot/dts/tegra124-venice2.dts        |    1 +
> >>  arch/arm/boot/dts/tegra124.dtsi               |    7 -------
> >>  arch/arm/boot/dts/tegra20-harmony.dts         |    1 +
> >>  arch/arm/boot/dts/tegra20-iris-512.dts        |    5 +++++
> >>  arch/arm/boot/dts/tegra20-medcom-wide.dts     |    4 ++++
> >>  arch/arm/boot/dts/tegra20-paz00.dts           |    2 ++
> >>  arch/arm/boot/dts/tegra20-seaboard.dts        |    1 +
> >>  arch/arm/boot/dts/tegra20-tamonten.dtsi       |    1 +
> >>  arch/arm/boot/dts/tegra20-trimslice.dts       |    1 +
> >>  arch/arm/boot/dts/tegra20-ventana.dts         |    1 +
> >>  arch/arm/boot/dts/tegra20-whistler.dts        |    1 +
> >>  arch/arm/boot/dts/tegra20.dtsi                |    8 --------
> >>  arch/arm/boot/dts/tegra30-apalis-eval.dts     |    4 ++++
> >>  arch/arm/boot/dts/tegra30-beaver.dts          |    1 +
> >>  arch/arm/boot/dts/tegra30-cardhu.dtsi         |    2 ++
> >>  arch/arm/boot/dts/tegra30-colibri-eval-v3.dts |    3 +++
> >>  arch/arm/boot/dts/tegra30.dtsi                |    8 --------
> >>  23 files changed, 39 insertions(+), 30 deletions(-)
> >
> > I have applied this to the for-3.19/dt branch.
>=20
> Maybe I wasn't entirely clear -- I was proposing to include this in
> the next batch of fixes for 3.18 so that the aliases processing code
> can go in for 3.19. If we hold this until the merge window we run the
> risk of having largeish parts of the merge window unbisectable (more
> than if we merge this as part of the next/dt contents).

Alex sent out two patches today that should go into 3.18, so let me
prepare a pull request include those and your patch.

Thierry

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZJWKAAoJEN0jrNd/PrOhw0UP/joUlwvdWbrpyImPDifXe7kH
Fu1XVj7CNgxE9QE3PgFY1BcW29NZ+QBPlgWyKZ50BXTlQDkgAcmW0/16nqScUOCm
NVAupEvP1+wEPrsXV9QJWkDKUADTljozvHt8IbTwpjzlxGJz0VwIeQfooPptsxth
iKDQyGvOIUMeKbZQ+DIsokymtmLMSIiGw9Kc6cfC6dF/rbhP/BJtWBCdCeQuqZKf
3Zz0lLN/vazCquXG+mc26nQVZ4xPPLq45omNq6No7YHVbYfFECBzjExR1jkPZBdY
lfLVUE4KCDjVIoymNGlvLD3sCDUfCbAMtsCGfRe6vfAP+pg3q8yYXvmxmJ9feE4Y
qmWfP2MC5h1kpTM/sPj8MLllak0OR/K5oM1D8rkBBO5QTKPr5i6YOpFTcBrR7+gV
Dt1PbjgKq11CJ94pqdr15028qbt2vx0+QQ8Uh/YcxxZGWjxwUAneC2uTdz5CWExa
Dd5jqjWgzLqsi3BgbOrNJMOvl7HWhgbVtBIQjtGL/DBag719tK6QlHDEtW4PsU/T
UFjrK7Hg/A+C19QVv3ZHYKVajFh0nZ+r0Qx7o3lnlJkcXo4wI0RrobTw0qkb5xb9
wWRXtQkLPlcHIRq2KqlQuUzdL48YTdqBgMEmJt88NwLu6k+m4In4QYV0bvpCJwAS
oiEATliDEMdMt7UyVc66
=K5s3
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
