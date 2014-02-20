Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaBTLVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:21:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47228 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBTLVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:21:40 -0500
Date: Thu, 20 Feb 2014 20:21:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Yunfan Zhang <yfzhang@marvell.com>
Message-ID: <20140220112130.GW2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nQXjnc5j1tYZagPy"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-4-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/23] regulator: fan53555: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nQXjnc5j1tYZagPy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:04PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--nQXjnc5j1tYZagPy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeU3AAoJELSic+t+oim9XD4P+wd9swKHCGcvcKlUQZ4SOjcp
AnB43XhrRGyxda02r9PjfMtYmQfrHWgUXd0H45Zf8gfOBT1YsjMH7QrB4+zvEAp9
MOyvUhjM/AVs88RmZt+++J+yceTfad1BFZe5YuHRfX2+uuWxi5KmnG5IMHQv8K6n
ybuighPGuOhHD7xay46VvpuOitQPIbL6gSYDDDPSJh359YCiGSshBKHhP1q4J+tI
c0zVodZ1TcTiYwebo19lKBFPVf5U2T77xHOt+DnNiXE9uuhht3IccW5Bgg3RD9ap
Z3Yn0xouacg8MFYMh0/2Xp2ThBKy2EdQhV5fvgZcqDmxhgeXiGWhkab/kO6jxIX4
fFXyyKy7tDigkzqexEKspDI7TE/ECb7gIz4TLbCtWR4A9lWpvCB/am9+6reW/6ao
9Nr7z3+DiNdYX9596u1lm1S9LrbrL1AY4YsymHKg7xo8yltXndCGAMD2wvGQZxmt
P7W4zUbHfR40/BN/pTRtCSZvBV1sedJXrXI6v1QAjdKfHf3376vw17z3gsnXCJ8+
D3TWEGL0DdwqVTmI07WqkvjmcLuJALzRQbI/tgdt3iw8ooSqso7qJjMff6p1i35h
6GNhmODGWk4UJpjxPfEDFU0cJ1smDOZRmIrmkjcZSsBgSlFmK8eyC6uhafDPRYYe
iruoqHBNRG+BQTBJVBRX
=/PiQ
-----END PGP SIGNATURE-----

--nQXjnc5j1tYZagPy--
