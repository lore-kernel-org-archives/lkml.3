Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3FJUJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:09:15 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49684 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3FJUJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:09:11 -0400
Date: Mon, 10 Jun 2013 22:09:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jay Agarwal <jagarwal@nvidia.com>, linux@arm.linux.org.uk,
        bhelgaas@google.com, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH V4 2/4] ARM: tegra: pcie: Add tegra3 support
Message-ID: <20130610200906.GD25859@mithrandir>
References: <1370445221-17696-1-git-send-email-jagarwal@nvidia.com>
 <51AF68F1.8080307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <51AF68F1.8080307@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 10:36:01AM -0600, Stephen Warren wrote:
> On 06/05/2013 09:13 AM, Jay Agarwal wrote:
> > - Make private data structure for each SoC
> > - Add required Tegra30 clocks and regulators
> > - Add Tegra30 specific code in enable controller
> > - Added Tegra30 specific properties in pci binding document
>=20
> It's a bit odd to send an updated version of just some of the patches;
> reposting a whole series is much easier for the person applying the
> patches. However, hopefully Thierry can handle it in this case.

Yes, I think I can handle it. It might be good to have Jay look at the
final patches when I'm done, though, to make sure I haven't forgotten
anything.

> > diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.=
txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
>=20
> >  Required properties:
> > -- compatible: "nvidia,tegra20-pcie"
> > +- compatible: "nvidia,tegra20-pcie" "nvidia,tegra30-pcie"
>=20
> perhaps add "or" between those two entries?
>=20
> > +- avdd-supply: Power supply for controller (1.05V) (not required for t=
egra20)
> ...
> > +  "cml": The Tegra clock of that name (not required for tegra20)
>=20
> Tegra20 should be capitalized in both those two lines.
>=20
> I assume that Thierry can fix up these nits when he applies the patches,
> so you don't need to repost. Thierry can correct me if I'm wrong.

I've found a few other nits that I can take care of myself when
applying.

Thierry

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtjJiAAoJEN0jrNd/PrOh3mcP/0f89iNTjFV7Hcu/CqXv9cm0
cEIdW9/98jwXHQxvkhsKLjkH58khuvi9tTqlzkaNJ1tesUZMNGNsFXz/VyLioKlF
+rR7XQD0bDhmDJmbrIzT6A2cXz0LttHSSzrisxG3gblyKop4jPW0nLsgOElC+Bfy
Ih/dadL3mHjoatabXiBM8CgtEuAnbnH+NQndMaIY2pavBvT1JRQiiMR+LP1LnrsG
5PORPybgvj9SkXNS8RdyDVGJw/CQQ0cGStKxzkRhp2Dp4PmoXKj3gO6XMWGx4Vzs
ZMUemze+//25Pw3i+a34+P1kwmRxnoNjCDwn/H757KijgtGV17GtpNwPZgg4YfiE
o1+dM/G4bob1xRGLsMkNw+QXzbH82RREYO+LycwP16pzBiIxbxTK8mMZQjmSK2KF
pga2VIhfPxJoF9afVjiuqdm0W0LquUGknCNpBcdQ7CNjR4gGQPcrZQpmYqmagwY7
Nn3DjViptoOybrKSpX9up0OwFV8QIZIX9TONXCJotdrXZV5avxX9nXWpNKejeoV2
crYYftUufzvZFAO/4OufBNuQZlYN3G58giwcrNQ/gYyKgqxRPCd4aHfVaxCAXFt/
xzBkMZ40Mo8U9ElRDFhfqdRXhUmah1jLcZkgLLConuDzUhhCWlU3GOPm/TFUobcd
Yxi30/eOa66xNh3IVPW5
=sA4U
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
