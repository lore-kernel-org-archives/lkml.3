Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776Ab3JPP6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:58:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40911 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3JPP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:58:39 -0400
Date: Wed, 16 Oct 2013 17:56:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for tegra clocks (resend with some CCs added this
 time)
Message-ID: <20131016155621.GC20211@ulmo.nvidia.com>
References: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
 <20131016153550.GA22451@ulmo.nvidia.com>
 <20131016155336.GN5643@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <20131016155336.GN5643@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 06:53:36PM +0300, Peter De Schrijver wrote:
> On Wed, Oct 16, 2013 at 05:35:51PM +0200, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Tue, Oct 15, 2013 at 06:36:20PM +0300, Peter De Schrijver wrote:
> > > The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a=
8cb1cf:
> > >=20
> > >   Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +10=
00)
> > >=20
> > > are available in the git repository at:
> > >   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-pat=
ches-0
> > >=20
> > > Andrew Chew (1):
> > >       clk: tegra: Set the clk parent of host1x to pll_p
> > >=20
> > > Mark Zhang (3):
> > >       clk: tegra: Correct sbc mux width & parent
> > >       clk: tegra: Fix vde/2d/3d clock src offset
> > >       clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2
> > >=20
> > > Peter De Schrijver (3):
> > >       ARM: tegra114: add missing clocks to binding
> > >       clk: tegra: replace enum tegra114_clk by binding header
> > >       clk: tegra: PLLE spread spectrum control
> > >=20
> > > Thierry Reding (1):
> > >       clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d
> >=20
> > I think this pull request is missing the initialization of the display
> > controller clocks (TEGRA114_CLK_DISP1 and TEGRA114_CLK_DISP2) from
> > Mikko's Dalmore HDMI series.
>=20
> I don't think they were part of the original request to be included?

Not sure, I certainly sent it to Mike for inclusion at some point. I
guess I can respin it on top of this pull request. There is another
small patch required for gr3d on Tegra30 which I can rebase on top of
this as well.

Mike, do you want me to hold these back until you've merged Peter's
Tegra series or would you rather take them all in one go? Until when
will you be taking patches for 3.13?

Thierry

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXrclAAoJEN0jrNd/PrOhVV8P/RniOJx92hJxKtxbUsRuyFwB
j2Gg0UdsKVhahWZhLmSJG9xbYd5aKc3OCLfgkvDkiSNMm4MIpkBxFhDJw+Q9gCoA
VKSipcrt305viSYEqGtBmscMX9A2Z3QgeCsbgxTUMBmF4nkI+pqaFqQjYG9oQGgm
BMoamInucH8uF+0PQJLQDr5qvwocodekrF9bVHAhZUFLnp7WdlO1MM5q9k01O3P1
+xPvYpKym1Nc+VbzOBeeQm+lEdCittjXTCakQgL+0c6+XOVk6TOb8emqqsSRG9JP
jwh5NolmL0seatHshmbHaCi0Nw/u80kRdv48abe/DeOVXSBNvMJ6qVWVlAa+YC2e
dy9LSluF/uX7QUz2DP147glpqBoNldhphbGgomxaXuG0QCyqfYgqosd3357+hYjC
1zi9zULqZwhcdkwfPCKhpqpSgmpJJs9xzS4iUYcdk0fpBBUXtFEQqIc8+I8IgiT7
VUCy5sh5ES39nUWRzsVIdN35pl9WmBJAxPRdA3QiK+6c2fbRUSdAZZRbPYbQVUVc
f77BJdUexLLvJehCe2vth08OMSS4uC26kQViYnxjZYGo1thsUtJjog7n+9PkZphT
IxOf8AhVNlZmOkxng+ul6JxiROG/cLzqS7h5dJQyryGc0VCav0opc3Euyx7jYkUX
5qy9i2jeofPbsoS9O8TQ
=iVzt
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
