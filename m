Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbbAEN7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:59:21 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55716 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbbAEN7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:59:18 -0500
Date: Mon, 5 Jan 2015 14:59:13 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/14] clk: tegra: Add EMC clock driver
Message-ID: <20150105135912.GB12010@ulmo.nvidia.com>
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416312860-4446-13-git-send-email-tomeu.vizoso@collabora.com>
 <20150102162750.GA10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20150102162750.GA10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 02, 2015 at 06:27:50PM +0200, Peter De Schrijver wrote:
> On Tue, Nov 18, 2014 at 01:13:14PM +0100, Tomeu Vizoso wrote:
> > From: Mikko Perttunen <mperttunen@nvidia.com>
> >=20
> > The driver is currently only tested on Tegra124 Jetson TK1, but should
> > work with other Tegra124 boards, provided that correct EMC tables are
> > provided through the device tree. Older chip models have differing
> > timing change sequences, so they are not currently supported.
> >=20
> > Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> > Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> >=20
> > ---
> >=20
> > v5:	* Get a pointer to the EMC driver at runtime, to be used when
> > 	  calling the EMC API.
> > 	* Misc. style fixes
> > 	* Fix logic for rounding down to a high rate
> >=20
> > v4:	* Adapt to changes in the OF bindings
> > 	* Improve error handling
> > 	* Fix comment style
> > 	* Make static a few more functions
> >=20
> > v3:	* Add some locking to protect the registers that are shared with th=
e MC
> > 	  clock
> >=20
> > v2:	* Make sure that the clock is properly registered
> > 	* Bail out early from attempts to set the same rate
>=20
> Thierry,
>=20
> How do you want to merge this series? The clock tree part depends on
> tegra_read_ram_code which is introduced earlier in this series.

I guess the easiest would be to take this all into the Tegra tree. Apart
=66rom patches 1, 12 and 14 everything would go via that anyway. I'll also
take some time this week to give the series some review, I don't think I
have looked at this code at all yet.

Mike, you "looks good to me"'d patches 1, 12 and 14, does that translate
to an Acked-by?

Thierry

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUqpiwAAoJEN0jrNd/PrOhuisP/1VhdBHOa0g2GCKTUZHAe7oo
VBGsyGXdjkvtoUUw1BRLyyZzhXavHuJ/FAmIHoSYTnU8E/97eeI9PsAXJlIh+mwu
+YkuqGyzmxBH3o1isO68U3OQboOb6sXUmCTUJ6O3zAjJxY2UdY2C+8NmBihHw3uv
KhVuRe6p0I+Alodh4MZSvbpDZhPWoyYna415J/Lo0Lku0e/XwmWwpNa7MBuLkL/X
eAf209Vj8kZ/IHmge2g4CTDwDl/nq0Jtk9erANYrwZdi3IhKa/g07ZBZIM0yhS9U
fLMXIiCmY4S0N5hKMsnjI6v6YrUf9DDnk7JtyRjKvQMFeXjfsZLPpeIG/Ze692Rd
GNqRg7ydKjb98+ELhZxFpWyLNNA6xXuw1/4EHyT8oPHfBV5p1owGY8ZDzD7esAUY
wgpSHbXYsl4OfmNM1TjlYGfIIwVpyum5ES+y/C7/RLZBWExDFwY2oSVTCWAoQ6BE
uEfm/EZPJg7qlg9JeDy+jNnsL1mCqHSwF6YFyc0bIXiOZT2cTBz3ozfVGeSwChQi
fH7xZlXwNsjrPV9P9bmooLU5ukQdEUsGgcuNpqLSa500fRy72EFoL8Kg6LB7vq7P
hXasfy2r1Tpx5Kmbtlm0xfA4WOjMkq1/Lo6AwI7u5hL77ccYXXzJyzvatXGek9AQ
q8AdPMjDj6qnAQWz7y8W
=FTEm
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
