Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3DXGrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:47:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3DXGrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:47:07 -0400
Date: Wed, 24 Apr 2013 08:46:59 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: markz@nvidia.com, tbergstrom@nvidia.com, amerilainen@nvidia.com,
        swarren@nvidia.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next RESEND] gpu: host1x: drm: fix missing unlock on
 error
Message-ID: <20130424064659.GC1429@avionic-0098.mockup.avionic-design.de>
References: <CAPgLHd8X3pLTM5vsTnHWL3g9GNOrxVF-LkmGWp6_doFkX2_LcQ@mail.gmail.com>
 <5177490E.7040509@nvidia.com>
 <CAPgLHd981uTJHuQAE_komRn81nce8zdzr+a-v43VJSPCDBgRiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <CAPgLHd981uTJHuQAE_komRn81nce8zdzr+a-v43VJSPCDBgRiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WKxU8NHcGvkcNK7ri4lwwUHy0q9oHeNY0nlFR/Z77sH
 fCAbrvI4C1ZYoTEORZUA6KPV0KeIleOr8i7VudmX0dHUr9Knrr
 IwYoNs38pl8hCbzAZjX3+u/fqQFgr1dUe+x5VoxenUg/f2TzVI
 ueF7nSPB/PWO43XdU/wPyHjiZ0r0l9tVSzxR58OVBS+naUKhUn
 EnF9H/8QsVeEoGh6vZoBBWmpVGfFxObvIV0YJ6pBDQkVV8qnYu
 eUTozxYPg7Qx0xSSyf6RCkFo/vT/vKG6P+eBPr68x6WnPiJBV1
 J4Cq+UjDkD/qzIkXCpQnkON4xqX1Ahf/kJINWZXKgPqPFseTsC
 ocq6dFm0XIDsHCjDM1N9B9HLdh4DmcLziPnus5CeReitxPg4OA
 5xCfXxkOzIvnbJvCRzEH3vq+GZXGJlJJM8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 11:07:30AM +0800, Wei Yongjun wrote:
> On 04/24/2013 10:53 AM, Mark Zhang wrote:
> > I think Thierry has acked this patch. So why?
>=20
> Yes, Thierry has acked this patch five months ago, but this patch does not
> applied util now. And the source file has been moved from
> drivers/gpu/drm/tegra/host1x.c to drivers/gpu/host1x/drm/drm.c, so I am n=
ot
> sure whether this patch was lost.

This slipped under the radar apparently. I'll be preparing a fixes
branch soon and will make sure that this makes it in as well.

Thanks for reminding me.

Thierry

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd3/jAAoJEN0jrNd/PrOh7DoQALYdWq+eJXeSe3ubKbW0NNhN
uqSHWzS/XfWvlp0Kj86K+7toCkqelBpfpgHMu1KvECFFv+qy6J3H/bm89Flk6LUY
DfHFuO1thzs2JhzCytiCvUXL1gIsv5RYDUNmVqMn6BdGvIx5eTSa6BeqawV9J7t6
LgOlSminq5XsIt48ppwdljqrCteZkJJ+ANTpQXRkd/DVaa7iiaXmCgCbO1XY8oid
DL0xest9RYgqv+Wty72x9SGVBCn3CGC3l0aTzJk9R52zvCXFHOK5IGQPKGLO0a9D
HtQJyeYF9ugMlrQGTdEGCE6VvpnInSokymkb//8wi/zadImUUnRpKpP4WcLyNocs
lAd0J4PWRV8CMnnkzidRcTPNebw9K8kjuOXkBNwIevNL6Lclkg6Bj+VFJN24ObJa
F41a45Gmk1Hu/NGwKDNIrS7QQVz1zya23xB0NXh5Xq8POfi8RB23i5xrS8F0rrtK
Bi+CsNiXxD53w4tszqdiEX00fJAFExUvQwEys0m5vcchOCZ4EM6kvWOI3CiGPx9V
Eu1EzoL4mES2HFHPe5Y6m4qaDNEKIedhqSbjGIbogZIr16OiA8mBiMWdtal9peIP
UKthatBENON1+uXfNQn5EaLAcWy9tCrVIElpeJOlQNd2XAv/MOiTvDuaNFvmrjhm
tFoZ4GIAm+auyeUdfc+N
=tWYO
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
