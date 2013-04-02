Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262Ab3DBJjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:39:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555Ab3DBJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:39:08 -0400
Date: Tue, 2 Apr 2013 11:39:04 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] pwm: spear: Remove unused *dev from struct
 spear_pwm_chip
Message-ID: <20130402093904.GB856@avionic-0098.mockup.avionic-design.de>
References: <1364790588.9357.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <1364790588.9357.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:279AFew0uGOAty0j6W3kWhmLj/WUCOi9aB9tCbY2AH+
 rrHRKQuIp4n9pAUlDw75DcyBFmj96cSSDc0KDO7k547kBTBlRJ
 iJKE1BcFHM2esdeWuqeQTihsFLgpQQfirc//PAByltO+pcy4Iy
 yCzGYN3ccd9Lr5v8xjGUDc9YUQjZ2fUfsd56FC1sAH21Ur49jG
 y4tI10CClFXkpyx8pW3ju4pjmqBrsYcv9th77QCbF+nZHgOiB8
 84x1wdLnyVzqUoZghT5U4TKKmboGzWu2dzNZmrP5QImR3fHI/2
 J4jQtG0BNI8HZFECib+Fp/Kq41OT40ISYhVIKujPBMg/DUAw3R
 MYawC/iV72UN4akJ5b6PDcZ23/P/z5tjxJ+Cv3TPchzDQG1iob
 2kqmFl/3kRzFU3+TA8HbdM6FxTMoTh2qd0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 01, 2013 at 12:29:48PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: Shiraz Hashim <shiraz.hashim@st.com>
> ---
> v2: fix the prefix in subject line
>  drivers/pwm/pwm-spear.c |    3 ---
>  1 file changed, 3 deletions(-)

Applied, thanks.

Thierry

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqc4AAoJEN0jrNd/PrOhTFUQAJzZqLkgrH3ansZ/+M0VKKaB
XFNN+emMAbViDEgqISsvrqZAbbvijdiIm3MEcAqshn4G9IFhdMd8naJNECq4QEkq
fihjdWgwJvZOpHfWDVpZjMvtALUB19sqzSbeT7eQPW6NUnbgDZ82cTmA8lb0cWP8
5ZBY8zU2Ly3xQ5XCM5JF+b1DpdQ1pA/5KlcIyn5HBbQpkBzplAaHPtaL3dzMOm41
2NqztVlwE0XVarNVmMonn60ura+xxcpFi2f35xfEzLOim6Rcmkfn9Q0FXN5d7iXj
raumpI/eE7yvhzvfOy8P/dZaQr3EoDSXEegxZv9wSW3UBAP4UzuG0t3vYJ0vVca5
G/+nn4h0Al4/av1x7e/RqaJnKDneSL6Tc7xkAMpzbbmES/9nYCAk/73eOF1kIWMR
Ob90tPeptNfcN95Yay4u2NOWCDFYx4S4uNFPNG7sQA7tXE/mKXnzshpTaa5ObhIi
MfwWVfNECLzZJ4aQYwkzvfVygLnHWcJhY58VFtj743UHwmECu3un/NDB3uWRA9t2
is892/EwgQQDLmtR2/y/KlV2N1zadrxncTRw3Cl+s3RhvGG2n/mZ7ox88V+qnkRK
M6z0mTJ6/uc5BaGNXF9PwkQTBVEOj86w/oalVMxn/Om7ZgFz2uFalqn1MrUba/9t
tOsl/2pLhUGaeOCuYl93
=0aA3
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
