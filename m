Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3CJWeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:34:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3CJWeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:34:09 -0400
Date: Sun, 10 Mar 2013 23:34:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, swarren@wwwdotorg.org,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] rtc: tegra: use module_platform_driver_probe for
 module init/exit
Message-ID: <20130310223405.GC4743@avionic-0098.mockup.avionic-design.de>
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
 <1362852588-13362-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <1362852588-13362-4-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:uzv/odVWRzyEm7XwwM3DeRe0t2hqrjicBuinJtEsPAr
 Jwn6Nw52xq5m+I20Cjn+dnwBZJBrL3QEnW6olcmqNYfDQOkJ0P
 Tv0VvGBHt3SGh9T5hMv/4yBtEu54rvEY032sG3CusjdviPwVZX
 ycdNa703rtmQSnwFWp3Uk4ITxeFg6/WsCwIyxyvnCViaHUZX6f
 W1BvuHMeYGkaA1qdkGDdT3H0fdMOK8F0Xan/fzFe9XfUA4GQcP
 YE3LNoBK8+dlf1SnRwAKmSgqc7w7+xinBw8sPwOdYgHyk7xgY7
 X1gB5nFbAgKiVuw4qtRMujfq6OigPbQO/uZ/I+aHbrMRQOMncD
 484VdJ/4OsHL10lyanafgGusxdjoZ+QHQloFfZLUVmpG0jZCgN
 0jRxCPwCcT8ykZP8uh3oZfEbAiBd/uzq04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:39:47PM +0530, Laxman Dewangan wrote:
> Use macro module_platform_driver_probe() to reduce some of the
> boilerplate code in the driver.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/rtc/rtc-tegra.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQpdAAoJEN0jrNd/PrOhtaYQAJP2nuZRRIimVOe8KZj4aJDN
7HA996VPkdL4mvOg854Sr9i9wYn2afAhxMnoDfj0Jpit8NUSTPzliINeQeV5ql22
XcV83jW3y7UjG2/yz9TJRMqqoGkXiLdQHxmUi7CZmK3hTZsc4cbT1wk5oq36jrgK
7+KzNlAOy7pNNWf1XbJbBzbE53bJBRRpoBmXPNKdCiYxB2cpDdUEyWtW7mEQNETR
mxRMotROLeK4HRjIKs8HERkatttvSgAyVCMkVp3LTeu6Vqn2sfp6wdVmY34VemEC
Rv47+UDm2LnGimyjkPC35teOIMR2sZoKdkQgQy2aIEcZDaFj068Rw36HvT7cSJ6l
bTM7UODoT5fq490fTPHBF36kUVagJArsONhoXu5Vz1A3n+4py8KL0q8ne9Ed/gXh
aTwEcvr4Ue3u09pgEr3Bi9Ky+mI19QvHAFS8fUi6dYhJzMgVDBLPaCi46lS8IYaM
K8rZHL6qsKWR/6bUBbilSxn/O524Ht9ikXiBSQE3MvOtKZciP51lI8hIRhWzTIS/
ezQw0EI0uysq+FQmRxy6PUvN2N/pi5gnjfj9BoQ2e0oDC0DvW+kdRYi00mXKiONw
PZr08MuctDlI8F+b2ZDRqdAOForuZ7A7cseKJB5gxAr6Onzyf+OaO0qO/dT+fm+L
v8C+THXTxuDQ+e+3T6X3
=0oKM
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
