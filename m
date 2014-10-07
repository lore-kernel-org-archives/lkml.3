Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaJGSOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:14:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39098 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaJGSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:14:29 -0400
Date: Tue, 7 Oct 2014 19:13:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141007181349.GV4609@sirena.org.uk>
References: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yV94raM4eJLN8srE"
Content-Disposition: inline
In-Reply-To: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Add support setting suspend voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yV94raM4eJLN8srE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 04:43:57PM +0800, Chris Zhong wrote:

> @@ -100,6 +132,8 @@ static struct regulator_ops rk808_buck1_2_ops = {
>  	.disable		= regulator_disable_regmap,
>  	.is_enabled		= regulator_is_enabled_regmap,
>  	.set_ramp_delay		= rk808_set_ramp_delay,
> +	.set_suspend_voltage    = rk808_set_suspend_voltage,
> +	.set_suspend_disable    = rk808_set_suspend_disable,
>  };

Why are there only disable operations, no enable ones?  Otherwise this
all looks good.

--yV94raM4eJLN8srE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNC1dAAoJECTWi3JdVIfQvuoH/iNnOzs3gX3JgZcSVgB0MiTW
q447kCJkoL+fj+r9Ivkl2uIdzGprSJiCvL2/J2UYXkLpSUZxCgBpEEYdha/go0eK
m+wd+qfZfugd8EeQBxKqdg3t4C4mUur6AOMj7YD3rV3caWXzNE4kraPEt5g/y5Pt
A40dolAGkrqnynDsrm0vuvndc9ezqp6t6mD5H3+2W7H5TXgdDnOrInnqoZC7SBn+
6oPPr1W2xnP7mnLK5GbRaZZlKyLHMKjD7xv5DhWEhCIFivUCh89n+Mt/BStnxa4n
tvg91dtU98JVpo+jD9kXyDzYyXmqyGcotJ0AiFj+7w8fQo65PEc8+ZJwhVUXAjc=
=89PX
-----END PGP SIGNATURE-----

--yV94raM4eJLN8srE--
