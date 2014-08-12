Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaHLReJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:34:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60217 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaHLReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:34:07 -0400
Date: Tue, 12 Aug 2014 18:33:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140812173355.GV17528@sirena.org.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407861868-20097-2-git-send-email-javier.martinez@collabora.co.uk>
 <20140812165852.GT17528@sirena.org.uk>
 <53EA4D1F.2030406@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cEOMcfxX4pgkStGz"
Content-Disposition: inline
In-Reply-To: <53EA4D1F.2030406@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] ARM: dts: Create fragment for tps65090 PMU
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cEOMcfxX4pgkStGz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 07:21:35PM +0200, Javier Martinez Canillas wrote:
> On 08/12/2014 06:58 PM, Mark Brown wrote:
> > On Tue, Aug 12, 2014 at 06:44:23PM +0200, Javier Martinez Canillas wrot=
e:

> >> The tps65090 is a Power Management Unit (PMU) used in several
> >> boards so the same information is described on different DTS.
> >> It is better to create a .dtsi fragment that can be included.

> > Why is it better to do this?

> Is better IMHO because we have a single place where the tps65090 informat=
ion can
> be updated instead of duplicating the same definition on each DTS.

But there is no real information in this file.

> This appears to be the current trend to better manage shared DTS snippet =
across
> different boards. Others examples are arch/arm/boot/dts/omap-gpmc-smsc911=
x.dtsi
> and arch/arm/boot/dts/twl6030.dtsi.

In the smsc911x case that's a block from a reference design that's
commonly repeated over multiple systems and is therefore similar to the
reference design elements that have been factored out for Chromebooks.

The twl6030 fragment is just broken - the regulator section is actively
harmful and should be removed.

>=20
> >> +	regulators {
> >> +		tps65090_dcdc1: dcdc1 {
> >> +		};
> >> +
> >=20
> > It appears to be largely content free, exactly the same effect should be
> > achieved by removing the entire regulators node.
> >=20
>=20
> Yes it's content free but later "[PATCH 6/6] ARM: dts: Add tps65090 FETs
> constraints" [0] fills the FETs constraints [0]. This is a preparatory pa=
tch.
>=20
> Also, having all the regulators allows DTS files to reference the node by=
 the
> label if they want to add other properties. I can squash this patch and 0=
6/06 if
> you think that is better but I thought that the split makes it easier to =
review.
>=20
> Best regards,
> Javier
>=20
> [0]: https://lkml.org/lkml/2014/8/12/377
>=20

--cEOMcfxX4pgkStGz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6lAAAAoJELSic+t+oim9p7sP/jgLVc+w/PzeLnSjzIt88ikb
mEQbNUbG277Chkqq6AAjIP0T+S1Wi0hx9Mhms3eX4zxFZvGApWLpYmTvkyNEe97p
orcacx7pY9pp+BEGhkznIJozYlI6+t9YRJER1lTyvgYx+Qs49LkXgQKVCtxTtz02
JQdgW7qZ+I1BFgvl99gX723lRJ3n3IaPpVrFMjEXKVX0Uk75LFTWm4+DWAg/aV4A
GzJ9gz24OZy7KTeGfi8iuYgIvKvQ5tF/53hj1EncgpdRnQ4bkIrWov4CMXvD34gv
6GtnHJ89o0ScDbjpUNkylTwz48TWWv0lH/Akksn+E1s28EfggAbZ0qSreiGAGir8
uhg1RpNsWy70JJ3Ms1xa9sgfvYwyksKjy0v2jmJfCPt8QOZrzbaHPaiDYDnXAPJ8
EgN1JZ4l34jncji9YgJtfeV8qKuQCVSBn4X5cNyPhO4zEOTuHpAM2VJ9T4GDgnLw
XNLyTC7yNW3NynXsyWPZGEAlhBN3gDji0Z3ADp1MRYhFQBEeaXJLjXuGCWgNalvs
TLMD5cnZQR3YrE48pEA3bg7lF6WXFunQ/Za1pfQockP8wurTSqs4EfjETbYHPjiv
NfKwhxaFnPwOUZr+oirGhLy1oqHbcZ2Day50J43tZPmRJkOqcPVURrH4h5HgJ0xt
MptFNxpmQVyVrQYBHwEZ
=S/b3
-----END PGP SIGNATURE-----

--cEOMcfxX4pgkStGz--
