Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaJVVcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:32:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:45417 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbaJVVcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:32:51 -0400
Date: Wed, 22 Oct 2014 23:32:46 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 23/47] power/reset: gpio-poweroff: Register with
 kernel poweroff handler
Message-ID: <20141022213246.GB28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-24-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-24-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:39PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
>=20
> Other changes:
>=20
> Drop note that there can not be an additional instance of this driver.
> The original reason no longer applies, it should be obvious that there
> can only be one instance of the driver if static variables are used to
> reflect its state, and support for multiple instances can now be added
> easily if needed by avoiding static variables.
>=20
> Do not create an error message if another poweroff handler has already
> been registered. This is perfectly normal and acceptable.
>=20
> Drop remove function since it is no longer needed.
>=20
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Acked-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCJ+AAoJENju1/PIO/qaND0QAIvpv2Ml/B+gTy6SkQqxgDhb
KILai53ZTeT/dDLBw+HHRsnEkGIXCBzOdSjZi/FETE2Yzv2CQ16yf2f2UsksZiIM
CbPK0GXONsQaq2Rz8bMvf4Rc54Q93JU0AVEBmv9NWCNzpYg8rRF8Eb+QYDGYZVXq
5w2LU5qJxV6ut/AqWW1/3bIhfti28Qta9jrddRsSGtdPeo1VPgTnJrrM5b+1NS/x
8ZJ89iX6GoeWsh1Y8WhRQTcVH1+PfLcpgLpA9Zqld71JhUYtfPaUzjamUE3c9xZ1
mBF9M1j4IWOd2d9I6VoVeZw3jCfAd51JzhUaiBnoR6DJZ320ugHFQqnGGY6lACij
XH4nrSvqn18TOuED8PrPGzuo09JrtN/nfVUiAic46oqBDaJe5Qd0C3aN7p12CxH4
ynCYW40z4VnXNJK4WPMXYsoxbH6CaNbXC3ZfnxGKAZdJwFkaPFPLSbbXxmljwQva
shoPhOc74vFCvBK/fksZyRQbk5s3yOQmFpXUHYoZJzn3rdDsyVO3f9ShdwINzzU0
8RIpx9M2CgNkSbnXynDcPCHcHCuUkQUIJNxY6dJ0gE2VWIjWuxs9/bjZwa3dAd/k
3F8mwDF60bcT2qkzJPLPX4wDhNTKqzJanl9DSF0sV2OM6JIqcYWYMpUK/vHdNq+J
pIsG52uJZprI63JtaUI6
=qXzj
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
