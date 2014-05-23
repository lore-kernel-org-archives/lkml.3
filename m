Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaEWR4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:56:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40475 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEWR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:56:02 -0400
Date: Fri, 23 May 2014 18:55:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140523175539.GJ22111@sirena.org.uk>
References: <1400859850-24505-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pB4caHzgQjfI2BiX"
Content-Disposition: inline
In-Reply-To: <1400859850-24505-1-git-send-email-lee.jones@linaro.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.182
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Constify the pointer to alias name array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pB4caHzgQjfI2BiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 04:44:10PM +0100, Lee Jones wrote:
> Toughen-up checks for read-only regulator names.

Applied, thanks.

--pB4caHzgQjfI2BiX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTf4uYAAoJELSic+t+oim9uKwP/ihQlHlTe4NWuJFQjRDOEYzP
IUmZ25/Q31lKv6c0PuwGPxpFF9u8/aqMctzcmxa70N3SdYErh4GdmnfA/Je4VJMO
rZHoaecEoBEpHFtSC4/iOsOdzhnd9FISkBgbHNYJmYZbFPNMg/BuoWzcpYfNQNqJ
7mZwNtKl0jdbtWr9xy7+1ZCceU0GT7GhFWldUtASLBOiD+0MpwkRobLIQOVu/xOH
J0CNij66fJaB29Vdu42mFspUw8wQa+2nO0QxHG9asbphYLWvzAwzu1aby5PvT59V
/WzhRra2RtGgmb5TLpobvrsoV4GyXCiCsCoOKhJvDfAWfUPCXOZu7sqJzGGVxXs2
8Dc7mjeTcYv6fOt/Q466scyX2Epp/DioBzWeNNlHn08eDl4LnfbnIlVw4Qs2YLf6
BybMAru4znGkst/iqJ7ZPA4kyHKhDiXBH0lqprHfXzA3q3Fg5pMwlTXctdEOc+cj
FVh/UtwygFz3MKiPhwLxMwlbSIIwhK4NUiWG5heGZnkgplORi2S/zlKwjJUjvAQB
TtiXxxjcLUZXjgKm22d+UZlygw/lg90JElV2wnXshsyO1BJg4K9VrarPcp7YfpQF
EFbbPxLPkgOM5xvMjQ8ZIQ5mKf2zUA/zFtsAyxxRhkS5VevUUyHgBKyFnX2xyx2X
r4cxmxDjT9EwbAQrndb/
=VjrF
-----END PGP SIGNATURE-----

--pB4caHzgQjfI2BiX--
