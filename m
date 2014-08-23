Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaHWPAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:00:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57098 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaHWPAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:00:22 -0400
Date: Sat, 23 Aug 2014 10:00:07 -0500
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: cf@rock-chips.com, zhangqing@rock-chips.com, dianders@chromium.org,
        heiko@sntech.de, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140823150007.GK24407@sirena.org.uk>
References: <1408792382-17795-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hWKK+vUwUWSC3a08"
Content-Disposition: inline
In-Reply-To: <1408792382-17795-1-git-send-email-zyw@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Regulator: RK808: modify for struct rk808 change
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hWKK+vUwUWSC3a08
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 23, 2014 at 07:13:02PM +0800, Chris Zhong wrote:
> use &client->dev replace rk808->dev

This doesn't apply against the code currently in the regualtor tree,
please check and resend.  It looks like a bug fix sent by someone else
overlaps with this change.

--hWKK+vUwUWSC3a08
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+Kx0AAoJELSic+t+oim9cFUP/Amx4TKZ19q0CIUulWRglng+
ga6Tu0hZVh7vQYTSdwCurezQbBPu5oEchXWdwKxjGHB8O5WJDz83dtOKrU7QsScG
LgkkhhwY439r9zK7KC2TZ9l50Xj8LU6ONfBe9GzKuK2PsQLpafzJfuuNXwwlJrjg
efJHgU62DsJv4uMQgr8jmFLyNPW5uMtMKZHou2iFGkWx6dLlRbQAbH9Gp2LaJjCC
I3DkOz+R7mbL2rn/LIaA2nr71TRgOAYf+F7xWf8pltZO0DIsVbz5QQeXL7HpW0jn
tsUyMrvevqZh3l/xz9pJcEvBKajjw4xxh6S+CAWKouy/2pZuempqbLYPLTj5xe0v
xT3M/KKi2Vu6+vGPyyYhIbynmOqV7b5zePFJPOUqwdEe9tYMRvnee56ueTopMhk4
0hdaXjRs7P8i/WCv66VannaOixtNDlJObTyopsImt6RDyNnySwdsB+RAqSzaPYyj
8vdYNX0au9cvcDakrBe11I3C3d+zAkdVF7MBMEiZu45d9Up6pJuhxOTEFxccDQPh
VgklljtEGpSUbk4sNlSyoyItT1aAuAEKmeGySip3gcHwIk435VB4PPG/bCv8toQk
XVWwj3uCJeTmRC4qo7n+wa9loGCrRDoMBgEe5dYr1KUMUtAsDFIPdiVnVlFkhYlm
FOpjqmqGuSDSs+H2c8u2
=KNtw
-----END PGP SIGNATURE-----

--hWKK+vUwUWSC3a08--
