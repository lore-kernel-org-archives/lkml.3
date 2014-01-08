Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaAHMXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:23:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48648 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaAHMW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:22:57 -0500
Date: Wed, 8 Jan 2014 12:22:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linus.walleij@linaro.org, fabio.baltieri@linaro.org,
        lee.jones@linaro.org, arnd@arndb.de, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140108122237.GV31886@sirena.org.uk>
References: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/iItXaCv0tvGsnvo"
Content-Disposition: inline
In-Reply-To: <CAPgLHd9fB+tA=uAfE2s5i2ygySUyqG=DNpe7RQFNOv-kBxjL2g@mail.gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: ux500: Fix sparse non static symbol warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/iItXaCv0tvGsnvo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 06:13:35PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fixes the following sparse warning:

Applied, thanks.

--/iItXaCv0tvGsnvo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzUMJAAoJELSic+t+oim9u3cQAI1vxXzf/luz5b1buL2Ku7ub
LYUIhVSd3siBEWDClH6RmFC8gYmF3gFYSZZHiPAxJ2zPQKD2UxsGw1GODzwnOC6T
orEa4v9AS6vhuHfs4ZBNqKjNQLiQ7PcOOtOujt9pnQOl3t0Ax3MzVqIdfSi8rCYU
ZpbqffJMHyNQG2m2kEa8jpodYQ91RBJ9ERkQBOFfVZZHyWoSsBzc5HwC98uv5DNk
Slh5HAHgPujBWerPgTVGhk4lIYlcujaD5BhjWyqkHpj22k1XN0mf1fl3k7Gx+t7s
E6YbRkvoReUXyChixU7+pHqAwVhbok+a/cVPXDAM+MNy1eS9w4toux8qA9Rpz4mr
wQpDh5TD4sD+QNPD5NCPwOmIDJO0ovdXc7lAjQMQ88myIY8YuE+8Tamqe3vie6B8
n20FMfZjRlrBotH8oHdB/A+nRv0eQ2Bi5yMYWIK8Iv6PoMNVG8pS3dkL+X5QeaNp
0780e0jbl2ncYtczybx+pUxP6tKpJfd50lDirJL2sOHNG9omyGC3fL7xE2hLaKNK
x0QrvTtmNwZvnekOgY+p7kNMhRtVjct0Wz+YQHT59qg7u3+sEvXp7ileKOUPxSui
8svy6iVUydtpaNEd4L8+vS9JZWaDEdzBUcMPl/H8Q/eGEkYwhhQ7m3QhGNlE7uBY
fqJqOtJeplYsgnb+MJwZ
=SwHJ
-----END PGP SIGNATURE-----

--/iItXaCv0tvGsnvo--
