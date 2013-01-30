Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3A3Jcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:32:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3A3Jcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:32:50 -0500
Date: Wed, 30 Jan 2013 09:17:28 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
Message-ID: <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
 <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
In-Reply-To: <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6gmi4eVC71ySxCylPxDJOhg4ltk7QFHP/EEF2rAjHve
 mFqPvJmVqLf2BbbQ3nzp/32HA1ylHKnTltsfZsP4PchTllz9mr
 FY+JrIom+itU/tKJ8g4goR0JPCGXD54i7nChOiXrCozWOOd/xh
 QDdzatFTPJE+J4A/EmWH+t71Et08w5paDsiFBe315IuOvpwC71
 RAKaEnmOXrPjMXWEqSolqKkBdzHsoqLKc0GIMQl8E1Ds3rbN+3
 G3N04yyq6USHf1ZatLRQR7E+86qjdm7oRGhncd/EikKeJbx1hA
 l+myrnefqcjg5HAjLbCIzTiQoVseAnUzYV8PTxs1nuB7z8vF/U
 DwIx/5NL6jMH83co024yXYb+055Zm79KkWGv9JTZ+piasX2zM6
 NElwibAxom3DKlCht7b6rGAT67XZwbEIYwg8xQzwlF2bfb2pjT
 Kru5j
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 03:00:59PM +0100, Florian Vaussard wrote:
> Call to led_pwm_set() can happen inside atomic context, like triggers.
> If the PWM call can sleep, defer using a worker.
>=20
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  drivers/leds/leds-pwm.c |   50 +++++++++++++++++++++++++++++++++++++++--=
-----
>  1 files changed, 42 insertions(+), 8 deletions(-)

Bryan, I assume that you'll be taking this? It doesn't apply cleanly to
my tree, probably because of Peter's recent changes that you took
through your tree and Florian based his patches on top of that. The
conflict resolution should be trivial, though.

Thierry

--rQ2U398070+RC21q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCNcYAAoJEN0jrNd/PrOh8qgP/RVBoZgUzQWp2cPuiWNX+DOK
xxUsTQNfMs91dMjGgmKzdjtAjBgX+/pIam9PyENy/wbTjFL6Y2z59v4J5OQFJjnP
ohgaqAHSDrnck4VRcz+OEojUsT0/QcBS/IBhzmRC8ATq5xymC1aeUeh9uVh9MH22
yrtR+AXLMQD9/IYmQznJl4yK2hbVhAs1gCfZhzSp10c17c9yE3v5D+krcXINS/Ew
UcxyT1cY0M9YkTtE6QxbwlJfIfq5MELmNyEdzqq2TBW5OwnnyGoRXccV4XMR7uAM
FmLmDshxZ4NlAoCNSXlwvMb+an1TVZ6SGSfoPjqmqI0oLEgUkaB1CGrTYsiXn4US
s+v4QKyRIh2hPXGi0CAePSqj7NjrYNt2fo5bUARVoE9ptd1nEqy2IWLmBS4p061w
xySpueK4nLwxHx6vbaLCaNZahccx8x9rR7o91IcuY9gHri0cYt0Muu5Na2ns1gyX
ZyeB5DpAuBHOyEowBq9D6l+/gv16pzlefwbeYfWYRXaKL/aOpDDMZd3UcQ4qTqIX
0nTWstfZUfj7MLI4BK8mcWD/mq8vBj8iuN1NUdYdw52NRMMqbxQKRpic3cVgK+bq
uV1vv3h0YKyR3MXs5mMJlej/EjweePvDb2AZfX6t+LR6TlYEPZ9aUSWzzmbXZe6b
Zfy1/5c6sgM0a4dy9jFn
=/WIu
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
