Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaJVVdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:33:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:45471 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbaJVVdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:33:09 -0400
Date: Wed, 22 Oct 2014 23:33:05 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 24/47] power/reset: as3722-poweroff: Register with
 kernel poweroff handler
Message-ID: <20141022213305.GC28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-25-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-25-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:40PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
>=20
> Drop remove function since it is no longer needed.
>=20
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCKRAAoJENju1/PIO/qagWAP/2ynT+dkSEzfz5Ib+vnOw/tk
RVmP4F/xsxr6iVHwJkBhen2b78+FWb6kV4be+GRPqMq0Fng2x8o/haK1E4esvPFM
nXEcEmqWWnglm2sbBcaSe+rh5tkV7b/P6p18Dic899ep9/r4y7HlPW4pIjMVeUJa
rpmMpvRP6bSXenwj2bWEp3rZCGG8LuTykNxRq+cplCyIT7wPi2dqj23EOHXTPEHv
AU1ADNfiA44n783aWJikPfSTYlxB/5MHisnNULCSRkWavuxE+9p0LY9npmqUgSZS
8uLFjpfpmMNBdxoAm6tch332HR8oVa5T8jYuN2dMRx4Ae4cE2k6nJSsg77vKujLT
N+WP7QBWNfYapPkPjo74/qXwU2mGri4Z/xvEATX7OMwKKnsJbT2WejMI4afy2YUh
O0uRbVJK5yGP6VVFTFc6XQOjfUvZD07+AGnFwiENnRaxJkFJ3WcH7scDinUaqKLO
FCLDyCEIfNFBtw2J2vY7vuI3yTBHxSiLaVWb14jH7jGfwL/RKpSxzLZXT4r17scc
M3IVKKzASWEG+13F7RDi7hZRcWllFsLwFpAZ6e/npa2cuCQelhB3Z/8yTs/7Zry1
SCIQKI5OoSkMGYsVLkF4O4S+nBtWiLV9cHeexTCeYVOuYPxOJBdANpy3LMkdYSmN
YQCyUJBo0aQaYyg3Qmhk
=Xf7Y
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
