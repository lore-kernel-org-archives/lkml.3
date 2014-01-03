Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaACQYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:24:00 -0500
Received: from sauhun.de ([89.238.76.85]:52510 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaACQX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:23:56 -0500
Date: Fri, 3 Jan 2014 17:23:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, broonie@kernel.org, dianders@chromium.org,
        cpgs@samsung.com, t.figa@samsung.com
Subject: Re: [PATCH v4] i2c: s3c2410: dont need CPU_FREQ transitions for
 exynos series
Message-ID: <20140103162351.GI7132@katana>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
 <1385439767-18586-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VaKJWhUROU/xPxjb"
Content-Disposition: inline
In-Reply-To: <1385439767-18586-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VaKJWhUROU/xPxjb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 09:52:46AM +0530, Naveen Krishna Chatradhi wrote:
> For Exynos4 and Exynos5 SoCs from Samsung the i2c clock is based
> on a fixed 66 MHz peripheral clock, and therefore is completely
> independent of the cpu frequency.
> Thus, registering for a CPU freq notifier is very wasteful.
>=20
> This patch modifes the code such that, i2c bus registers to
> cpu_freq_transition only if CONFIG_CPU_FREQ_S3C24XX is enabled.
>=20
> This change should save a bunch of cpufreq transitions calls
> which does not apply to exynos SoCs.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Applied to for-next, thanks!


--VaKJWhUROU/xPxjb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxuQXAAoJEBQN5MwUoCm23DgP+wTf3YlfmOrh7G+lpYvsgqxQ
r16o7AOEnjZbJkOE1sN6LNcrCiH/4jAJE756ZBZZGTSzQh6FAb0UPi8abUp18Rzq
wpsndT//AyhoZKaO6E4qnj67089jqZc2C83+xZrvHJjxXokIz4kfB7yVfHJEsViK
Wpxtgt7mOxDSF/FAul+ayEw+lSblTBT3y+xF1oLcLPvgl8iMpdzwLSuXkFmrQALO
4hvOLEh1hfeYafwN8AYMcvgZAttJBrpjDjy4dVScGdQd4RdB0zUCFcSSdonCsBlb
Hj8ZOSirqN45S6LO7njJL7nImcYmU/r0+atdKHiHKSpayqJBi74OURNciaUmSSSX
lBFDg0e5Mw41QYryqSmxfbXO7VaF+SNZ9KzApk64MHCFbTNaYrhaColOsFHMu0Xx
1fB4wQJD2xFhTQP7Da9uZEpytoq4Vay5TBEMGYiPwQ/u/+Z8E5giZYjoMzgzP2Ki
4zzlSiGEd0NiZLa7OuIvA7eIrZmEKrWD7rEesSCm5OEO7MHZnRcKEn7bdOlRgGsL
8yAjyKCiSLeCmepG4MlR99obIPuK4cp4oEm622orV/Yc2kaMUXRMrGzSYIbtlrBH
g6hIJQRTaZdqAsqS/kSm1ShjoXwj/QhpXBnpwXWKbmBc3rprkfx+mUEEDuLBEEHZ
btRMTWVtR7dL+YSPOpBU
=+/YN
-----END PGP SIGNATURE-----

--VaKJWhUROU/xPxjb--
