Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaHMIDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:03:37 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41103 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaHMID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:03:29 -0400
Date: Wed, 13 Aug 2014 10:03:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: tegra: Add PMC thermtrip programming to Jetson
 TK1 device tree
Message-ID: <20140813080324.GC7735@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <1407226380-747-3-git-send-email-mperttunen@nvidia.com>
 <20140813073736.GB17466@ulmo>
 <53EB1932.9040601@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <53EB1932.9040601@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 10:52:18AM +0300, Mikko Perttunen wrote:
> On 13/08/14 10:37, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Tue, Aug 05, 2014 at 11:12:59AM +0300, Mikko Perttunen wrote:
> >>This adds the required information to reset the board during an overhea=
ting
> >>situation to the Jetson TK1 device tree. The thermal reset is handled b=
y the
> >>PMC by sending an I2C message to the PMIC. The entries specify the I2C
> >>message to be sent.
> >>
> >>Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> >>---
> >>  arch/arm/boot/dts/tegra124-jetson-tk1.dts | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >>diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/=
dts/tegra124-jetson-tk1.dts
> >>index 624b0fb..ee178c4 100644
> >>--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> >>+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> >>@@ -1617,6 +1617,11 @@
> >>  		nvidia,core-pwr-off-time =3D <61036>;
> >>  		nvidia,core-power-req-active-high;
> >>  		nvidia,sys-clock-req-active-high;
> >>+
> >>+		nvidia,thermtrip-pmu-i2c-addr =3D <0x40>;
> >>+		nvidia,thermtrip-i2c-controller =3D <4>;
> >>+		nvidia,thermtrip-reg-addr =3D <0x36>;
> >>+		nvidia,thermtrip-reg-data =3D <0x2>;
> >
> >Given the number of properties that this can potentially have, I wonder
> >if perhaps it would be a good idea to put this into a subnode, like
> >this:
> >
> >		thermtrip {
> >			pmu-i2c-addr =3D <0x40>;
> >			i2c-controller =3D <4>;
> >			...
> >		};
>=20
> I guess that'd look a bit nicer.

Mind you, this may be somewhat on the edge of what's considered good
practice for DT content, so maybe wait for a second opinion before going
ahead with this.

I don't have any objections to a set of nvidia,thermtrip-* properties, I
just think it's fairly redundant to keep repeating that prefix (and it
causes ugliness in drivers, too).

Thierry

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6xvMAAoJEN0jrNd/PrOhUGoQAKFYgJWw5Dcf4o7OkuiyjBFS
uU66r8fIBiPbDfwVzUqg7hjZrnPR2G/qE6nZJnqJ9LSymqNtuUsHmUzuJTfggnBd
cs9kVTUt4PuKlbEsfmWjCEnABb3KKJmmmRfQwGP+fmgjyjhXLhxEjubTYmxZoUvr
jJc/ZDXfcG2mit6JvY1aoObZsiA5QfTUSdpkbjSaEoTvzkGR+b9erMly9SUOhp03
kRfd+C6l2m8615VTUfRIP4x33VGfj9QtmMYvYF3qJLnW8bDBYFRfu+zmHX1eN3tI
6DoTfYqu2OaYWVRzMdBprHaunAs/XzuUPpm/LxrckoB2aMwfP0yVErVbeyzaWpMl
QKVt+ittmrMnAGUlSwN3T9AwVjX9Cntzul9q95/k+7VQ+nq4Qbvh2hlHMx/Sickb
ppX0aPKLSdXHOBm+4b+j8koR41ag22sbuXh+H5tzMbsdV0ORD71p8zTaUhlwFiMx
UF9LJdiUgS2d8c3gJTOK1FdbXMXYWCt20LBRLNKNVY/4WkvE20Mvv67FQl0AL2C1
QNRXaS9dCT70OI9o5yZ7f6muBW8zp7g1wzZ5B0su0iLD1H958C3D3lOOXOJxiYTt
3nc0nJfHqoP2BuGNZ5JzhF8n4IVbm/jP8t+hr/1K+kT2s3gYeFwM1NRdayn8tbId
sYi29RC1Yo29MqROzWsK
=QWkL
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
