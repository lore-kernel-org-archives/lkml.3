Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3DVNTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:19:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab3DVNTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:19:07 -0400
Date: Mon, 22 Apr 2013 14:19:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Taras Kondratiuk <taras@ti.com>
Cc: lgirdwood@gmail.com, rjw@sisk.pl, viresh.kumar@linaro.org,
        shawn.guo@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philip Rakity <prakity@nvidia.com>, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [RFC PATCH 1/2] regulator: core: Add regulator_set_voltage_min()
Message-ID: <20130422131904.GL30351@opensource.wolfsonmicro.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
 <1366372554-20866-2-git-send-email-taras@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrM5Z5VIJgwP9LWp"
Content-Disposition: inline
In-Reply-To: <1366372554-20866-2-git-send-email-taras@ti.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nrM5Z5VIJgwP9LWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 19, 2013 at 02:55:53PM +0300, Taras Kondratiuk wrote:
> Sometimes it is a need to constrain only a minimum voltage
> and let system constraints to limit maximum.
> Add a new function regulator_set_voltage_min() for this.

I don't believe you on this one.  It is going to be a very unusual
system which has a maximum supply voltage specified at over 4kV (or
more) which is what INT_MAX will come out as - there will be some
electrical specs for what voltages can be tolerated sustainably.

--nrM5Z5VIJgwP9LWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdTjBAAoJELSic+t+oim9t8cP/3kE055Pw/JDlG9NDvqAKmzk
3huv9JdVlfP6h4OOHf3q+iXeKveeubJdZRWabWg2wxseFQnHOu24Q5eawALZhgjy
mFzBf9dMROfcNYWOi64mTuqRL01+RWmRg16H5wjclDUMLwTJ/oiKSICuNGUneHqr
fC5FKpvSlWvFJzX5zxzEmcF0QOqGtZ9zx7XOZGskSPzK1LcLwVVNfD1YkHL4z4qy
jomyCNsZKFcof3oeDQj/K1tlpC1em91eWHG3qnoePC4OT2kZkMxfU4XDSNktXXug
ve9KyPgyOw6/LUX1H98yZlIO6E6YNmdgX0e+VpL5N/jOjrRBjV7bekYoWKMLbR7Q
cBkioM3IfNjw+oJ+bYp+mJJ5g6rXfXZxXbGo5nI8zGRXudA6ucJ1iEmYqv9zJ96p
PBdQgxVQjX4DxBtWKPyXwCjIM0h9TL3L8Ou+baU4ZXbju6grUX++GLPr9nPKmMOg
KCEQjZ7YncGUsZZuLlrjVxJo+O0tB25ZyxGCZpSgQCsRKw0XttyJSdbsfsRMJOGv
DXNe/A2boYSDCOTDirYIIh3vXQxeG1iZhANDEpf1Ql96Yt0OpfdjQRiS12uZv75C
XVySD2s+7x/JE+HlJlhJJYC8/3747ERqoJMsUSYpp08V2nZ+LR70jsFSVRs8xyfF
Ad8oNem1wgzlnXl+e6P6
=d7iS
-----END PGP SIGNATURE-----

--nrM5Z5VIJgwP9LWp--
