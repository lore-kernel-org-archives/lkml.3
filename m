Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3FQKLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:11:34 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:57873 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3FQKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:11:33 -0400
Date: Mon, 17 Jun 2013 12:11:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
Message-ID: <20130617101127.GA24519@manwe>
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
 <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
 <20130613182447.GB32574@mithrandir>
 <20130613131415.aa4f675f151c586f5f6b2123@linux-foundation.org>
 <20130613213920.GA32732@mithrandir>
 <20130617075925.GB5008@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20130617075925.GB5008@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2013 at 10:59:25AM +0300, Dan Carpenter wrote:
> On Thu, Jun 13, 2013 at 11:39:25PM +0200, Thierry Reding wrote:
> > On Thu, Jun 13, 2013 at 01:14:15PM -0700, Andrew Morton wrote:
> > > On Thu, 13 Jun 2013 20:24:48 +0200 Thierry Reding <thierry.reding@gma=
il.com> wrote:
> > >=20
> > > > On Thu, Jun 13, 2013 at 10:55:17AM +0530, Sachin Kamat wrote:
> > > > > On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wro=
te:
> > > > > > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resou=
rce()")
> > > > > > introduced devm_ioremap_resource() and encourage to check its r=
eturn value with
> > > > > > IS_ERR(). This however leads to the following sparse warnings, =
as
> > > > > > devm_ioremap_resource() returns a void __iomem pointer:
> > > > > >
> > > > > > drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorre=
ct type in argument 1 (different address spaces)
> > > > > > drivers/net/can/c_can/c_can_platform.c:205:32:    expected void=
 const *ptr
> > > > > > drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned =
int [noderef] [usertype] <asn:2>*raminit_ctrlreg
> > > > >=20
> > > > > CC ing Thierry who has solved this issue some time back.
> > > >=20
> > > > I had sent two patches, one against sparse, the other against the
> > > > kernel, but none were picked up yet.
> > >=20
> > > I didn't know that.
> > >=20
> > > On May 8 I queued
> > > http://ozlabs.org/~akpm/mmots/broken-out/errh-is_err-can-accept-__use=
r-pointers.patch.
> > > Dan says that sparse v0.4.5-rc1 or later is also required.
> >=20
> > So maybe latest sparse does have the patch. I didn't find it looking at
> > the logs. But looking again it seems like an equivalent patch made it in
> > recently. Also the above patch looks very much like what I posted back
> > at the time. Shame that work was duplicated, maybe I should have pushed
> > harder when I didn't get a response.
> >=20
> > Thierry
>=20
> Sorry about that.  I didn't mean to steal anyone's patch.

No worries. If the issue can finally be closed up with sparse 0.4.5 it's
all good.

Thierry

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvuDPAAoJEN0jrNd/PrOhC80QAITjnFi5Et+Apbx3QhTTaw4g
jr/Mtd9BkkRL0iZVbacJBDOXBrLsWKHeu4C+9vrQ11ldz6P5oUBF9NXausxSPc3k
qRHaKgPx7vTFGyVoVxx8bqzpxxTPzGhohl/2+kpk/pIbEJfsqauUqDaHvmEv1qLj
urvNVhRebGZK3u4aiaxrbNhA0UVg+QVWjHqbdb6uDMS7MvoPhH+plrWhqIYhgkwO
znFWyZGR3FWFAdKAGtitlrlgwL7ohbiAfOcWzzzb3MiFgvi1libiWgmcSKVgt32p
yg2ZKLUB3F1C0MDt8kvkxfs5ihEx6kmuN32R6F6QsKF72lyVHLgz6QyZuvVj9gNj
Jk7H4+9M7bMX4qLx/fiidwuNNjinQNzJtIlo52xKnUXYX7dA+apealQOSDq2o7uz
erZfSCvkUOlsNOjhwj0NotqNr+J36p09r9RyPkLH86fRlNp8uwlOJ7h2UrL5Hcll
3EdFdMe8VEiDwFuTEy0bZyibA8yBbX/Xhp4AJm+HL77FsKlqNCliVabdJ+O/kc6z
YGBs0Qc2l6TUENjHLtLPbJGo6T1p2MTKc1wuNHEMHhsxjD+nG+HiRZCLfCVaVqOY
i2hm4o1fiviFA+M03jCQpgo3xYDEFZIYD4qiSU83lqzol2+57b60ykg1aL4NLiqb
puRoQ06ESAFNs1J55Xt8
=Vsgs
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
