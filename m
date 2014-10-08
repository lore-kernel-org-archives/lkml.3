Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbaJHOfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:35:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40792 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaJHOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:35:13 -0400
Date: Wed, 8 Oct 2014 15:34:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141008143439.GB4609@sirena.org.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nu+X7QXugUj78Xnb"
Content-Disposition: inline
In-Reply-To: <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nu+X7QXugUj78Xnb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 03:44:05PM +0200, Javier Martinez Canillas wrote:

> +- regulator-initial-mode: initial regulator operating mode. One of following:
> +	<1>: REGULATOR_MODE_FAST    - Regulator can handle fast changes.
> +	<2>: REGULATOR_MODE_NORMAL  - Normal regulator power supply mode.
> +	<4>: REGULATOR_MODE_IDLE    - Regulator runs in a more efficient mode.
> +	<8>: REGULATOR_MODE_STANDBY - Regulator runs in the most efficient mode.
> +  modes are defined in the dt-bindings/regulator/regulator.h header and can be
> +  used in device tree sources files. If no mode is defined, then the OS will not
> +  manage the operating mode and the HW default values will be used instead.

...and as previously and repeatedly discussed this still gives the user
no way of telling if or how these modes might correspond to what the
chip is capable of doing.  This really needs addressing rather than
ignoring, for example by not trying to define the modes in generic
bindings.

--Nu+X7QXugUj78Xnb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNUt+AAoJECTWi3JdVIfQ0jwH/jMxJCoKWBeiy9HsDqEoVCAJ
wYn32QHWujgvtnZ4oB1FsrWcN0g6c1naph65d54DDspJwnAOWAFEoMEvOzxPwOTQ
5W9dsbK9f/yYNuBYiL6Q6esID5sbKJzegaQbnoJMW6r8m4xJj0AjU1XFiliUJpFM
BqdUomeyhtDp6N5KYhzWOXQp7MVQ3BTYCbdw7BV0Zt5r1C+s2PKdIZX7jMsjRuUV
95Wv96EDVJSOvkl9bAeH164+U8pYkHqehja0W8zy06zbLzJTqN5gTYRnFnznwWgi
KLS77LUqL7GVy+6VVVdtjU97oSp3mh1Sg32MM3ltI8RHabd/VDqBFZhtnIBLqlM=
=pZBq
-----END PGP SIGNATURE-----

--Nu+X7QXugUj78Xnb--
