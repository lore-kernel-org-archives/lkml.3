Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab3CDK63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:58:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3CDK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:58:28 -0500
Date: Mon, 4 Mar 2013 11:58:06 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
Message-ID: <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
 <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch>
 <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de>
 <512E2F98.6070404@epfl.ch>
 <51347B06.8090604@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <51347B06.8090604@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:pFj9iYPFgORgKdVx61Q8oYYHcpsQrg/bMFTwqAYH4N5
 sBaEN+hnTtWar2QtYCCFJtYuxuhKzVNF8lv/eOPsqEkTY3giSJ
 1Xrt2EmDgfToVCcUdJeI7ENhuAKfl3tTLoOEg5pchNfOB+bxQZ
 ew1sC4xyRAs/7iHOa4ft+brVP1oO4Ce5jhrllsKqLlRklA8mKH
 xf6k6bUiRQ1eLkYUKc+ARLBpdtxLsHNA/yIqb0JKBxrlBimKTY
 tzEWYHOyO6a2NEtz0qURegI7njaGovbDEnRpMQK1VAsqCBg00s
 jo6P+7DFin90xyt6zMtBEhkUNqIubic8lWpX2X3MOp0Qod6JGC
 XO/xo5Li4bgmwHv5P15vnjhOhjO8q5Q9zeMZ7zVHxJfm9Sz77Q
 RE9CsWNgOCrmgWZ0i1A7nWDgKR7hnblilLNcfYH2LjF0bLbFBy
 1B4KA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 11:44:22AM +0100, Florian Vaussard wrote:
> Hi Bryan, Richard,
>=20
> >On 01/30/2013 09:17 AM, Thierry Reding wrote:
> >>On Mon, Jan 28, 2013 at 03:00:59PM +0100, Florian Vaussard wrote:
> >>>Call to led_pwm_set() can happen inside atomic context, like triggers.
> >>>If the PWM call can sleep, defer using a worker.
> >>>
> >>>Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >>>Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> >>>---
> >>>  drivers/leds/leds-pwm.c |   50
> >>>+++++++++++++++++++++++++++++++++++++++-------
> >>>  1 files changed, 42 insertions(+), 8 deletions(-)
> >>
> >>Bryan, I assume that you'll be taking this? It doesn't apply cleanly to
> >>my tree, probably because of Peter's recent changes that you took
> >>through your tree and Florian based his patches on top of that. The
> >>conflict resolution should be trivial, though.
> >>
> >
> >It seems that this patch was not taken. Could you pull it, as the other
> >part is already in linux-pwm? Or is there any show stopper?
> >
>=20
> Ping? Who should merge this?

I assume Bryan will take it through the LED tree? Patches 1 & 2 went
into v3.9-rc1 through the PWM tree.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNH4+AAoJEN0jrNd/PrOhkH8P/1dteX8ngslP9WwbqcTUHX2j
HrghK+Ptf8XDditK6VXa/CYRC1qPsoZUao/eBtfwYpej8IgRO60th2UOsCTX42o9
I4DFGGnHH7j7rdi41NJRWcpg9myRGtpmdtxvrqnLz5ZE7iAumGJTxD0pRo27OgKe
NG4lG72KJAI5ts0jIuVRjZcfuSXKaEb2N0gMCWQzc3hXDYm1qttmClTwJHPXujfp
x+49bAVoEhQTJxk+8ZUuh4KCztMYC4ekz6o3rcEKehA3yRBhj+ZW9E7pz7RBPlh0
nWKy1O1ZwRnIkFV9a5wUWJGgCfo3/fzTmYiA7zL/lOC07cKUd9Autrev72bMfhZj
1EAK5dvaRUlBolEvYULBIhuEwy9XhY7o65PK4BgnlmquEsNiuVzoN94BMpGvHr8b
IH+1eqVOlbr9rXjBKhnZ3GO2AGJ7saidnioPqZwsH4n2JMcoBvOgYeFDatD8FAwx
JPS0nDfAnOcyPn5roOe9QSkPITgzDvZAkL9cerCe/T3XLGH7JvIihR0HSCERTnqF
rB1LQiWLChk5Zo4+PCsE8thYHttVME1mHdXgT5p8vyfhSss0RTXJ8sMZeo9AubYj
Yb+H2djRhMs6HjC29vzeiIrLjYKUqkbS1cndQQ5Mubx2gFQNCBCI39Da8tO6V7Z+
W0uaHliGrIlYVO2T7nsG
=J7Uu
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
