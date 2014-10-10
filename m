Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaJJHBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:01:49 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46364 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJJHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:01:47 -0400
Date: Fri, 10 Oct 2014 09:01:42 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: tegra: venice2: add GK20A GPU DT node
Message-ID: <20141010070140.GA29675@ulmo.nvidia.com>
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
 <54376A45.6070707@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <54376A45.6070707@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 10:10:29PM -0700, Stephen Warren wrote:
> On 10/08/2014 11:11 PM, Alexandre Courbot wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Add the device-tree node for the GK20A GPU and leave it disabled by
> > default. It is the responsability of the bootloader to enable it if the
> > VPR registers have been programmed such as the GPU can operate.
>=20
> > diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts=
/tegra124-venice2.dts
>=20
> > +	gpu@0,57000000 {
> > +		status =3D "disabled";
>=20
> status=3D"disabled" usually goes into tegra124.dtsi. A board would only
> override status to "okay" if necessary, and include any board specific
> properties ...

True. I guess this is somewhat redundant here since the .dtsi file
already sets it to "disabled". Given how it is rather unusual for a
board's DTS file to not enable a node I think there would be some
advantage in keeping this explicitly to avoid confusion. Alternatively
perhaps a comment in the DTS file about why this isn't enabled by
default would be a good replacement.

Thierry

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUN4RUAAoJEN0jrNd/PrOhZsgP/iE/Xqhzo+/I6KaRGGltk0st
5qPWxNB6iSAaQUxxbbgCv37US8OY0aG2tpBXWwJZtpL24ST40ljPZ0m3Sa5UEUAq
D0OQzJ144RzT9pW5weMfds7qd6afuBWrWnmZsvs85fpL5UXKfcsCSa+CfnZoWfxu
PsyXZEGCeuxvd6Nv/QPfbzkler0Mmv3dVFNPYno/QPtMxDH4ztYJEieMiW6Q1u5z
aTEEY4HOOYazTrRcE8+FGCwYWWgc2fRBET3oLTfL5SiPYR2JjFBvYC1ZE+QTjMXz
r28vujlnvki5ht1viiI4gk3G5favAcJ6CvIKC0p7ponUadcDaF3yR5zuxNejndhw
lfkvjl+8Aey4B1oYw+7+cLgwcK6kDdqQFJf1TAe7HxJywjqKSAJ5i51zn/6b7Z0m
p2NMUli6aYzkMmz5dRmqzso5tWiyWNIcAcrIapjYwQg52Ii6kkrDfBEpi7aDt9kP
I01w+gNDZAXTh7R67XOdWgRJqBQ4WQGN/5xZ3jxoQ1r+trjP0b/Lxp78xQrOJgQ7
Oy/SOvFUAzxOTtSuOnzgJuKxWD67ciX3BMCUIZ+LWsq+Qyb9GgJicShfYGscSnEA
2XTK6rMbhmdFnfo7ZNQXHomrzlFnqxLwGSZH6gRksJREotl9M4Be5gYVv7p0BGnz
YgYIJwIB9jXsQNYePYBz
=210x
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
