Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3DOQ1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:27:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56839 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023Ab3DOQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:26:58 -0400
Date: Mon, 15 Apr 2013 17:26:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] backports: add support for voltage / current
 regulator drivers
Message-ID: <20130415162652.GK15837@opensource.wolfsonmicro.com>
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
 <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
 <1365886878.1089.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VJJoKLVEFXdmHQwR"
Content-Disposition: inline
In-Reply-To: <1365886878.1089.5.camel@jlt4.sipsolutions.net>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VJJoKLVEFXdmHQwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 13, 2013 at 11:01:18PM +0200, Johannes Berg wrote:
> On Sat, 2013-04-13 at 07:13 -0700, Luis R. Rodriguez wrote:

> > This backports the latest regulator drivers for kernels >= 3.4.
> > We enable the regulator only on kernels >= 3.4 given that
> > it relies on the new probe deferral mechanism which would
> > otherwise mean having to support drivers that do not probe
> > correctly. Note that 3.2 had a base regulator implementation
> > but that was just stubs.

> Applied.

Please let's at least discuss the issues here, I'm not sure what this is
supposed to do but the analysis of the subsystem didn't seem complete.

--VJJoKLVEFXdmHQwR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbCo+AAoJELSic+t+oim9OzoP/AjBaQL3JwmcebLcVfupNJeM
vObnJ+pjjin7HWojxQ6WM6oMpqHpK9g76QCl8KRjyMVVXDojYgj26SO45ail/arP
4IYa8GB2sBvRHKvkENnhUeOgc0pw8ycqx7lNm/2xLG/6gqisGLBErImXRd2SAKml
Q2OtfKy++sEDmm1LJ7s6yvLmtlWkBTuopMAwn0ChLJ9/j9pgr9aZsa/un+iowOIm
Gr93GmWgohmKoHPzw6kO27p102P0B9Z9jJ873FRj32z1lLyoSJ6VT6XAFXqV394D
h0Psq2T5zWXaPhD3RCJ61wNlX71oFe0gyCrWIJiAfYVL+lbVVDTuQ+ZtQuaZOaxp
SQg5IMODBjoGyEgmpEcqBtSM1Sa73ukCXSQtMiiT7qMVDyUqx+doVrdoVXX5ddSL
zDjEfsOVl/1wYIIHedGs+2spG6sHgoieE74yhkxmUlx/JgCSC25Fn09GDzYM9pGd
JHEzjJy8OtMRZqnnLFriITFlEBMrSamtcjuWTqNhniHc389qNTbQh5orcUdEmmSO
2V3/jvy66GBzhY9EQzift3VP38EJArUVcdRmggSgsgLzbN7wjYHrCj3WdWHun6A1
EbOJBD5nMaW2uFkt9dn8LmrBncTBu+R20D49KvjC9SgBeycDBhIRvszhbP7JIGFl
EPqzgp/0TG4oc31J86Ec
=Ka9j
-----END PGP SIGNATURE-----

--VJJoKLVEFXdmHQwR--
