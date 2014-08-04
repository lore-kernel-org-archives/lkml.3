Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaHDP3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:29:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46195 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaHDP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:29:46 -0400
Date: Mon, 4 Aug 2014 16:22:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140804152252.GT30458@sirena.org.uk>
References: <1407136045-8940-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j5abB2DrWbqmv6QP"
Content-Disposition: inline
In-Reply-To: <1407136045-8940-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.223
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Set SYNC bit of TCR2 to Asynchronous Mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j5abB2DrWbqmv6QP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 03:07:25PM +0800, Nicolin Chen wrote:
> From: Nicolin Chen <Guangyu.Chen@freescale.com>
>=20
> There is one design rule according to SAI's reference manual:
> If the transmitter bit clock and frame sync are to be used by both transm=
itter
> and receiver, the transmitter must be configured for asynchronous operati=
on
> and the receiver for synchronous operation.

Applied, thanks.

--j5abB2DrWbqmv6QP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT36VJAAoJELSic+t+oim9ABwP/3ndUI2+gdawDpjqFp0aOxaJ
87fp0zku0Hqk/rH+W4yGDj2erflkRkZz3wvfMh0cUfIACltX3VkDh2oqX94wVXy0
y5BsJOfQB3o+FFMqUsgtYIms8DMBrM6ZWoqwNNo4khnbtwwmC0ZBahCrbsGpMTUp
oALZXwBbLaR8HM9rPxYOM23qMZYi2S+3w56LYko2tE98xI6pooTHYcH4RvhgemmC
quLeG1lM/Pab6NLr5Vfnbf8dcQPoCuXMT7ql/97aAJaG+hqSgMaUXVvuEfFlALtm
cNjE9tWTtkXcak04EriQSyOXeW3WWQbkI0gb9IPehQ/Qv9deOtilgFHzOSagDjS0
U6XROBeeiJNVr1ypyAaH2dqEKc0JCZavZapwlwfX8SKLOwmT2PEIBjkgXiF1moqm
WeoDUMBcpioNkGcpDeDj7UrHQC5xYjoKn3O7IqWKZqnMDi6EpBPG1esVUc7ocz6T
jc55+ZKHEkUgTWX+ajOoO4H0TVFTTSBBpCb3ssmugNZNfaqj04WkAMkd594nxLF/
RGLDAl/v4ZgRgZCkVUbJO3A8Zz0jg03yfVbaEroWav3wJA6x86BiY8U7N4WxZo42
OzQh4udzNgvA80IIQU+dAIyIczpRoVxPUBvw3N7aOA2QQz2aAsn1x3rTlf1q/B9a
Rmy/wCcilXiBxFuWb90a
=348I
-----END PGP SIGNATURE-----

--j5abB2DrWbqmv6QP--
