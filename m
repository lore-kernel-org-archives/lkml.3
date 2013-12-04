Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3LDKfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:35:36 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52155 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3LDKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:35:32 -0500
Date: Wed, 4 Dec 2013 11:34:32 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Message-ID: <20131204103431.GC26589@ulmo.nvidia.com>
References: <1380082975-6022-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <1380082975-6022-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 01:22:55PM +0900, Milo Kim wrote:
> LP3943 is an integrated device capable of driving 16 output channels.
> It can be used for GPIO expander and PWM generators.
> LP3493 registers are controlled via the I2C interface.
>=20
> This patch-set consists of four parts - MFD, GPIO, PWM and documents.
>=20
> Update from v3 to v4:
>   Move the driver description from the documentation to the MFD driver fi=
le.
>=20
> Milo Kim (4):
>   mfd: add LP3943 MFD driver
>   gpio: add LP3943 I2C GPIO expander driver
>   pwm: add LP3943 PWM driver
>   Documentation: add LP3943 DT bindings and document

I suspect that given the build-time dependencies Lee may want to take
all four patches through the MFD tree, so I've acked the PWM parts.

Thierry

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnwU3AAoJEN0jrNd/PrOh7oUP/ivmm5ud0khS1wkyAYvT9w4Q
ZLiIUS4+GIT2kHq9WArXn+69wkw4w9+t4CtWTIpoMBpLWPnVYpWe3ZSiysbk0E1R
v2dM5KYeorjEEoHS5voRynfVzOt58XUZ9QfODv8Nn0HOCgkmzCl+uPo21MX/KA14
iUeXV++lg7TMj+leMMaJaWClwMapLHg7q5U+x53DLMT2Qjw2lKdhjr5NqXKghuw+
KiCL0evwe6JCAQc/5TJDJZrsYaKM1MW/+hSistDB8Deh9v3MzV0xMvPD13Pw7Coo
nvezs7HawicHpihMkqG4oJxxARa0eFr9s62OcE9znU25twQbsXSQSnkT8g8StlA5
f9ECApLfciCG9awJl3Nq2QB66HxSAbW3Mz+3FmD00swYcvzSNT9xTu4sWPmhjdX0
9ZLGMMCH3pLp8TGfsGfDEGEDnbl/ZAesAxu2HWI+P3n2EkDCX6NLT+D2LmjfLOwo
HAttQ9gnZymTfN7ejhIIsO6gJObcyEsuOE8eArMaOYAXDtnznMbziDI0CcuFgcHT
o6nhQzuPnRdObfOZPnyeN2A5pZb2yLinklz/MURdKtFbJhgtVt2cBKGt08BUI5eL
W4tqyEkkzy96iyyBlRGGFPS93jEBm6m5j7RIEh4gg6ZjfcZ8vjtjV4hDMm4v/cgK
4paYhbBQzKXSU7bObC/5
=m/Iq
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
