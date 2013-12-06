Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162283Ab3LFNZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:25:16 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42143 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab3LFNZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:25:10 -0500
Date: Fri, 6 Dec 2013 14:24:06 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Milo Kim <milo.kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Message-ID: <20131206132405.GC30960@ulmo.nvidia.com>
References: <1380082975-6022-1-git-send-email-milo.kim@ti.com>
 <20131204103431.GC26589@ulmo.nvidia.com>
 <20131205214341.GC29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <20131205214341.GC29268@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 05, 2013 at 09:43:41PM +0000, Mark Brown wrote:
> On Wed, Dec 04, 2013 at 11:34:32AM +0100, Thierry Reding wrote:
> > On Wed, Sep 25, 2013 at 01:22:55PM +0900, Milo Kim wrote:
>=20
> > >   mfd: add LP3943 MFD driver
> > >   gpio: add LP3943 I2C GPIO expander driver
> > >   pwm: add LP3943 PWM driver
> > >   Documentation: add LP3943 DT bindings and document
>=20
> > I suspect that given the build-time dependencies Lee may want to take
> > all four patches through the MFD tree, so I've acked the PWM parts.
>=20
> FWIW this isn't an issue with new MFDs - since the function drivers will
> depend on the core driver it's not possible to enable them in Kconfig
> until the core driver is also merged and you don't get bisect issues.

Right. I hadn't thought about that. Thanks for mentioning it.

Thierry

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoc/1AAoJEN0jrNd/PrOhWfsP/3EVMqXytcQdCMZUQEyCKpbD
pWqG4ut8SBP6LwySxokdSzwRbgjYCb6xlaKp6AXqaJnflQjojLCz6YzOirXW2yAp
al5xCudum808Wn3XcX9f17fJeSm4GpoGay1wX6rEPx3LS/ADomk27H0haRW4QZjC
nG2JMNBLBUOXK/LY6/FGn3PL6oGMQKOkAIFJ46dK08yCZMW+Z8ugeVWgUDVt0lJO
76nXF1GVVpiV+HrQCW4JrYKBv7Za1oAtS+6dPp3jEwmgUZUy+3oYCR5HBz5BRCiY
+SxUQNQrCB38a0VFUR6E4yno3wxqMnXAEMjgx4kls3CQRCcV5fcTx3KrTiAkalJw
hxD2TtDXPgZvKl2Hds3DsUDGYlAM26LfGuTyoMEjW0lH261EqIqdFFClq+jfzV1x
KuZqW2Cpqvz0Y1tsR3+sTJQ/gZXb65xCRKVriFgV0/ly02q9IS+sUSglfBUfHLO/
QWjJ76AtfENIYMPdTo1kEvIUXjNZndrteL0BGvWTpgyhGMj6SZkoMT4yfsoFVxjC
w51EYFaIuCz55KKubdedln1rT7gCrTDLkjIVPKvYQuDjJsB7gjYETU28OjzEB+bq
axM1AFpV7aBF+6pJwUoHPqRSfK6tXFQuJhppFN2KSF6mqvAJ1A7IOQZWHXvvZXzy
y+TY5zTLnbAPkWOJx4YS
=m3MM
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
