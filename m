Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaHSHBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:01:55 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33672 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaHSHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:01:53 -0400
Date: Tue, 19 Aug 2014 09:01:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jonas.jensen@gmail.com
Subject: Re: [PATCH] fs: Initialize mountpoint list head in new_mountpoint()
Message-ID: <20140819070143.GB12859@ulmo>
References: <20140818153327.GA12278@ulmo>
 <1408416234-7923-1-git-send-email-mopsfelder@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <1408416234-7923-1-git-send-email-mopsfelder@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 11:43:54PM -0300, Murilo Opsfelder Araujo wrote:
> The commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736 makes next-20140818
> to panic because mountpoint list head was not initialized.  Initializing
> it with NULL fixes the problem.
>=20
> commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736
> Author: Eric W. Biederman <ebiederman@twitter.com>
> Date:   Sun Sep 22 19:37:01 2013 -0700
>=20
>     vfs: Keep a list of mounts on a mount point
>=20
>     To spot any possible problems call BUG if a mountpoint
>         is put when it's list of mounts is not empty.
>=20
>     AV: use hlist instead of list_head
>=20
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> ---
>  fs/namespace.c | 1 +
>  1 file changed, 1 insertion(+)

It's considered good etiquette and polite to credit the original author
of a patch. This should be:

Originally-by: Thierry Reding <treding@nvidia.com>

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8vZXAAoJEN0jrNd/PrOhNsEP/igW+CP1VkHeHpmODcUlFW4J
sbvfFo3DSAkludOJx43CTouwAeaJkDIjpfYWTti47XX3xPxeElPvrBzIykJo5nEQ
gxXfcTJtAS/mw5XkhYMDuNDJhjyoxwnSS55ADBxtIUz+ogFd1Df0JjhXabjG/LsB
PIebwgdByDZLBKUNENxROkcbnPx/+KyQPpuE8NuVHnR3nvErQYs/1Jo2dAuHA2IB
aDdSH0xU88AbTUzGbqdMPOsflVJBWomqKJ/z0uvLdRKnvaLrUj3dZjJQKBx0yoVv
v4QoIKZffEP1h5zwH+48zKcGSgvjIC6FpkMpKutP43n0ulT4xW+P68ANT5y1i1Ty
/Eny3SZgGF3kJB1faDt8qOU/ddPIC8z3m+Gt9Pwg/k5S0h8h4dR1J6n4NA99B0tS
jwZV+FOTrjcR3CD6MpRFM04V4yo+vgLCazfu5DfjNbcYjiYivv+EbJTNQhqQAA/6
/ORkJWDH3n1LKo4w3hOKTvANgJ9EGJh7h5otW48/j5bCs/l1Q1YFpJrQUcK1qKBH
GCA4rjlE9Piq3OlXn/NKEakBOOPwjItwkQe98PqtCoXolDWHcvleg08+KZMUji60
ZYhpH0iNGFBq0ujOCK9Tkv5leowNXqwPc/Xx/Bh1ha9Sr8qXYb7O03j4x60DiURo
yDDJkIQHiwC80D8JOfCO
=PN2T
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
