Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3LDKdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:33:16 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:39155 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3LDKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:33:14 -0500
Date: Wed, 4 Dec 2013 11:32:13 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 4/4] Documentation: add LP3943 DT bindings and document
Message-ID: <20131204103213.GB26589@ulmo.nvidia.com>
References: <1380083109-6284-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1380083109-6284-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 01:25:09PM +0900, Milo Kim wrote:
> Bindings for LP3943 MFD, GPIO and PWM controller are added.
>=20
> Cc: devicetree@vger.kernel.org
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 +++++++++++++
>  Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 +++++++++++
>  .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++++++++++++=
++++++
>  3 files changed, 128 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt

The PWM bindings:

Acked-by: Thierry Reding <thierry.reding@gmail.com>

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnwSsAAoJEN0jrNd/PrOhBVcQAMEDW02jT6UM3pGzNlGLgmJ4
Eob/QNLgxn0TMWr1JF2dNOT8rNOISIBdwLOJ7qXBPtrgyvCw9HMVrXmNVdGHwblY
IK9vsvtzn9hTq+sDqbIKCBagHOM92cZvhyPK1FcczJd2JidIjQ8/RUjyCTcvP8TS
Rtcy6nbpC0BvxONeDVPERMEI/FimF7CwqcW27802otz+xwthZg1VeI/lC8DDSjsr
oWWxYg2iTQGrcFwXOdmIkJduJs2m7yTr9/RUMBEkHpFM6aMzs5tWa+QOas74mFWG
aRpTaGx38EGpsfs7EOJ48CO3L6nnKGSNXJpqRmPvJifqX0aFrphlFr1kuP5NqyDF
B0P3HoZIytmwDAFlH7uPIxWA0rQ951XCbn9ticqyeFhVHYAOYHLYfpNXB1QflWhj
OG8QMsEUyUynDV+nvIa0nUC3h787PdbNAHeVFFBz/DA7xeZ3c271vJ0LUtUkOAXB
tAUx4cPuL/e0ZlvGBS35yEx41q8E+zfDdb4faMyEEC7ghLarnJ7K9j+m3icup+s8
NzX81FQBMsK7fggnwEXO/RB7lVuUBGVDtQFuVplwcXzuMhJ2n2t6dskiKfxF7TUr
GJ0Zxa307PVvfz5ZpcwoUkkFqIR2aiNAhnrK9dqjrV2x/jnuSj5f9neUK4TW0ZNR
Oqh2DgxAiUsg24EXvZ+W
=rb6P
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
