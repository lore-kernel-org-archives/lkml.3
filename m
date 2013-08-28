Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3H1AGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:06:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39517 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3H1AGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:06:52 -0400
Date: Wed, 28 Aug 2013 10:06:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20130828100650.717c22af5bea88e89371393d@canb.auug.org.au>
In-Reply-To: <521CD111.9030905@wwwdotorg.org>
References: <20130827182935.ff4005b60cc1ce80d32d5e46@canb.auug.org.au>
	<521CD111.9030905@wwwdotorg.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Aug_2013_10_06_50_+1000_m9n_HWRyBT=K9xCW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Aug_2013_10_06_50_+1000_m9n_HWRyBT=K9xCW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Tue, 27 Aug 2013 10:17:21 -0600 Stephen Warren <swarren@wwwdotorg.org> w=
rote:
>
> On 08/27/2013 02:29 AM, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the arm-soc tree got a conflict in=20
> > arch/arm/boot/dts/tegra20-trimslice.dts between commit
> > 30ca2226bea6 ("ARM: tegra: always enable USB VBUS regulators") from
> > Linus' tree and commit 23f95ef2d951 ("ARM: tegra: use TEGRA_GPIO()
> > in a couple more places") from the arm-soc tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary (no
> > action is required).
>=20
> > diff --cc arch/arm/boot/dts/tegra20-trimslice.dts
>=20
> > usb@c5000000 { status =3D "okay"; -		nvidia,vbus-gpio =3D <&gpio
> > TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>; };
>=20
> That chunk isn't part of either of the two commits above.

Yeah.

> It is however part of commit 103566e "arm: tegra: Remove obsolete
> nvidia,vbus-gpio properties" from the USB tree, so it's fine that the
> change is part of linux-next.
>
> I'm just not sure if it's expected for that chunk to show up in this
> merge resolution email? If it's normal, then there's no problem; the
> issue would be with me not having too much git merge conflict
> resolution experience:-)

It did not actually cause a conflict that I had to fix manually, but is
part of the overall merge changes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Aug_2013_10_06_50_+1000_m9n_HWRyBT=K9xCW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHT8aAAoJEECxmPOUX5FEwmIP/jrDc6YFUiWT17SGcaIGBDZn
p5VEMV15KR3bPwMbEG3VB9bPBrYdokSM93i/q5bKTHehHMKoMRg6xFKytstxQJlZ
dREaA4gTpYN/H6/zNcwiUvXz/cRxbeBBIcgroErbLehHlDzdws3opCuTfJbK3LKq
k8WGqAwMItorzVs5k0fjhv+ia6UtLngscJO+BS3quOCZWtUwtKfiUIlDLnciCZIE
cItUv+B5NcHyJfZ4BI33eoEyxKS/fSL8+Dpg+1oMeT0UzAhjbQXqXSKnNY03z7pg
G+EQqjuRUYnDV8MiF5CiJfq4QFKsil9obmysVee8oKlWBhClwQCGQzHjTbxOAyGj
NLkfXSYPxKz4sm2r3JSiRBNNvJcS1lyIAremD+rC+IC658P0xW7A5ghicN7iYpbm
DPgsAW8MWB0+xXFuUdDdeiZqmN3aQPf4wRPNsvOQhs1sH+IE2CfkojCHNCG7HVW1
DB0Z82PJXtkIDo9rKkOBuvCule4HTL7PWyR5PeA21wfigrlkq+ac5hQ6Ypm+6DkM
sJpRFys3ExkY57etzBx+5h0o1z1h4wNvbJJZBFPfeQJdFIc1S3flWF9nZAxmVXKN
nIyVIknUEMLPsebt3UmlDx08rohkl4+rcZGK18JZkyA9Fyl0LPj/C8BRRihS99oJ
gO8wwnjimd1rGNoNx3kx
=STmp
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Aug_2013_10_06_50_+1000_m9n_HWRyBT=K9xCW--
