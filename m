Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaEUK06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:26:58 -0400
Received: from sauhun.de ([89.238.76.85]:46878 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaEUK0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:26:55 -0400
Date: Wed, 21 May 2014 12:26:53 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, naveenkrishna.ch@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, cpgs@samsung.com,
        broonie@kernel.org, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] i2c: mux: Use subsys_initcall for the
 i2c-arb-gpio-challenge
Message-ID: <20140521102653.GK2708@katana>
References: <1398351922-1647-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG5hGh9V5E9QzVHS"
Content-Disposition: inline
In-Reply-To: <1398351922-1647-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZG5hGh9V5E9QzVHS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 08:35:22PM +0530, Naveen Krishna Chatradhi wrote:
> From: Doug Anderson <dianders@chromium.org>
>=20
> Since many drivers rely on FETs that live behind this arbitrator, they
> can't successfully probe until after the arbitrator comes up.  They
> ought to handle things properly with EPROBE_DEFER and still work, but
> that has some downsides:
>=20
> 1. Those drivers don't come up till later in the boot process.  That
>    really not so nice for the LCD--we want that to init early.
> 2. Some drivers have bugs and don't handle EPROBE_DEFER.  Those
>    drivers should be fixed but not all of them have been fixed yet.
>    HDMI is one example since DRM doesn't really have good support for
>    deferring probes.
>=20
> With this change We end up using the same init level as the main i2c bus.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-on: https://gerrit.chromium.org/gerrit/57007
> Reviewed-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Same here. Unless we have a clear understanding that this is the only
acceptable solution in mainline, this is really an out-of-tree patch.


--ZG5hGh9V5E9QzVHS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfH9sAAoJEBQN5MwUoCm2NKIP/RnXdE5wd+fUPW7J+JRAYKPo
TngFUG55mdvAiHqHT4PiUIbv+8HookLkmD43JdXt0ORbYt+AyAi+vAnwOfWHOFix
x4Q3ZRhwBTvPmQ3Lk96Z/nvgqKA5W47w8NGkXd9Q7lAoG2rgAcAGZeBT2hrqnho4
t4fqvjvMRtL3hC/JB1o4Bb5gUafjFxI7biDowLHH8TsW1jrTdpyp6u9fowDBLbr9
b8A9KHeaIvL/ckqnrWor9FtpT5V7IlMOkYwXVEx0FojiV84PHQPxXKD6/weKJQo1
F6YJFygH73EvudotETNqjgPibyik3/NojyS7cO3Uyb1Ivv67VIdKEyoUJjfHr3Yt
yhHJYFGDZazmyUKjlKtjd3QphtJLS0KIco1dK7E+86XxYv85nQiUDTzMrkbo33X+
VfKfArY52CM8XiAd4y44VvsxXgz7jA5sgn7rl71CGOXJnlko2W7FTlhB9GMAp6Gq
OqeGmVFVrKYC4n+Qp/qKeak7k4VBCqUmTFJeGQ+0QZO0lZM+ethdS+hcDWBZerdi
P8Mo06mWhRgi5Zu8ohQjd3OmFU3ZVgu3W1dGZKyftuCf7wXYycq5hm8AOufqV5D1
lyhTJH1AWYvSgBDw95O08hEMezxJbuueD3lf5am+AJaAoB5bMKJ3vPbJjFN6l8YJ
xWZxfOMro9pbUC2v+mmd
=8Gcc
-----END PGP SIGNATURE-----

--ZG5hGh9V5E9QzVHS--
