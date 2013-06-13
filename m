Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3FMVja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 17:39:30 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47582 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab3FMVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 17:39:28 -0400
Date: Thu, 13 Jun 2013 23:39:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
Message-ID: <20130613213920.GA32732@mithrandir>
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
 <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
 <20130613182447.GB32574@mithrandir>
 <20130613131415.aa4f675f151c586f5f6b2123@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20130613131415.aa4f675f151c586f5f6b2123@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 01:14:15PM -0700, Andrew Morton wrote:
> On Thu, 13 Jun 2013 20:24:48 +0200 Thierry Reding <thierry.reding@gmail.c=
om> wrote:
>=20
> > On Thu, Jun 13, 2013 at 10:55:17AM +0530, Sachin Kamat wrote:
> > > On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource(=
)")
> > > > introduced devm_ioremap_resource() and encourage to check its retur=
n value with
> > > > IS_ERR(). This however leads to the following sparse warnings, as
> > > > devm_ioremap_resource() returns a void __iomem pointer:
> > > >
> > > > drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect t=
ype in argument 1 (different address spaces)
> > > > drivers/net/can/c_can/c_can_platform.c:205:32:    expected void con=
st *ptr
> > > > drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int =
[noderef] [usertype] <asn:2>*raminit_ctrlreg
> > >=20
> > > CC ing Thierry who has solved this issue some time back.
> >=20
> > I had sent two patches, one against sparse, the other against the
> > kernel, but none were picked up yet.
>=20
> I didn't know that.
>=20
> On May 8 I queued
> http://ozlabs.org/~akpm/mmots/broken-out/errh-is_err-can-accept-__user-po=
inters.patch.
> Dan says that sparse v0.4.5-rc1 or later is also required.

So maybe latest sparse does have the patch. I didn't find it looking at
the logs. But looking again it seems like an equivalent patch made it in
recently. Also the above patch looks very much like what I posted back
at the time. Shame that work was duplicated, maybe I should have pushed
harder when I didn't get a response.

Thierry

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRujwIAAoJEN0jrNd/PrOhvKYP/0En05b7xldRCoaskMSZ8sAN
VuR5+NJ2Wp8KvmQre8a4HpryNkwL8y1HxMg+Pz1jV7Du/CLZt0S8KTg2Oll/KTHH
oo+TpYkxGDMDSu18wB8uTR89ZmYswniV581VGlkquJ2YXks7s/YvVilLk1sdX82C
ZXs7RV88XBjA4rtkaFRcC1rs1rJItsRn1x1/p7jr+2qzog7dPka4GGtgV2OAir8o
VEdnfS+8XS2F3ntyI2BITHxJb+bgnQeocrGKCAKC2LzOQSsyZEErKUeDBOfVHtZd
sOpNndvdc5qch3qnY9MR67+KA2QpCosav/RESbGLTLZhh+xraI2Jibt+sF+jXUdF
199gfaAcfssqUh5VcxXwqwHReSrhQfzhrBWRjhSw53FFO6D8QOCuyCoOvH4ZxosQ
ofivlwv4ZVJsLZjQqbJZ6WWDEUXOdH1cxxwtc2xF37+jrtzvjOQo2VIQHDSZLs6k
fN62SMq6wfUM7ks8fEJrcypNT2D2eFjxJbz9/Djz1OMDnVSrHmJmn7RdWPcCCvSI
w5FLRoBbATh+HVp0bh4juOCO5ddpabjqjYh2nFOHA8HdHwB3SwFJ38RAQQ3HoFYr
OgO/BpEl/ME0tgyM+QqMrGDPNRlEDsjq2gPQdU+660gISm8YJvqjptIG0mhjXUGq
wtq0WnsJmmUnzvvAoOqf
=r/w7
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
