Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3AKJT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:19:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51908 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3AKJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:19:54 -0500
Date: Fri, 11 Jan 2013 20:19:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: please cleanup the cpuidle tree
Message-Id: <20130111201943.f928f64c870ee5d2cedbf410@canb.auug.org.au>
In-Reply-To: <50EFD6F4.7030903@linaro.org>
References: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au>
	<50EB5636.4080705@linaro.org>
	<20130108102227.19d4102cb1ddf516ad4082d1@canb.auug.org.au>
	<20130111115608.dffec30f37e42a8f15a3f117@canb.auug.org.au>
	<50EFD6F4.7030903@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_20_19_43_+1100_UjAbbOh_rKmmGYB5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_20_19_43_+1100_UjAbbOh_rKmmGYB5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Fri, 11 Jan 2013 10:10:12 +0100 Daniel Lezcano <daniel.lezcano@linaro.or=
g> wrote:
>
> On 01/11/2013 01:56 AM, Stephen Rothwell wrote:
> >=20
> > Unfortunately, you reset your tree to be a version of the pm tree that =
has
> > now been rebased :-(  This is now causing more conflicts in linux-next.
> > Maybe you should reset your tree to be the same as one of Linus' -rc
> > releases for now.
>=20
> Ok, done.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_20_19_43_+1100_UjAbbOh_rKmmGYB5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ79kvAAoJEECxmPOUX5FEqdMP/RLIKUtgNWyAsMwuljlk/Qu6
3zWgwNyzu/i9nSGLG4g01ER3+l7bOlryIUpHLheyZaRZnz90gVuPF6kG78QcADov
PNoB+h9QvtCSVzR/zXxwb/rm58aNfdMsSkh+PmThno2U9QvT0yKNgK5Hytf8K3C9
p9ypYSjUP8vH+k4VjJUP1whUSv4yx+X9+aNZb3ajUoU/PrQC1Uis5KuVxBHW1e+T
1joz8gzDN28J3d8R8DUIpTIampTA/cCA6ZLoKZHiRTvqGk8GB2OxBl2qgirEgpqn
8ZRQAnyXCP0wc//VWeVAgsosd+DDPiIrZoCPIKRvwi9z4rf1G4qvONRV2SVZF5Rl
fFQ5juHyUHx7KTpU9ln7R6fuD50siXtLf/Sj2LONxgYAyMfd/3nUTjVujDHnZpVN
gRbb2AzeInzbk9kcmPkmaep1g4Q1s5nTdbKmOw9DZTUIJU80qWBTNdvmbbGF4fFB
pojFvM4JpFb4GVPmQGIIATSRBNklAfKp5fGDwGl0uDotvFxSzPtWmCf8axfsoNb5
YP0cXPXcaFyHzY+VLfBeRpmPPUhohCi19ePhfNiyXgHNEVl9yduUrNgaJUbBUlhk
rUCHJSib1trBi9ogZiVmIK7MiiDg5O548kMYWX1u16kINhzaaOSo5ZI+wwSNknsA
2G6X/pcEQaoCHec/IWsR
=Ef9s
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_20_19_43_+1100_UjAbbOh_rKmmGYB5--
