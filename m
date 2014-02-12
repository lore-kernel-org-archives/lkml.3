Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBLMU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:20:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40757 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBLMU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:20:56 -0500
Date: Wed, 12 Feb 2014 11:57:03 +0000
From: Mark Brown <broonie@kernel.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: lgirdwood@gmail.com, axel.lin@ingics.com, linux-kernel@vger.kernel.org
Message-ID: <20140212115703.GF28112@sirena.org.uk>
References: <1392181867-16952-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <1392181867-16952-1-git-send-email-sj38.park@gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9055: declare return type of inline
 function exclusively
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 12, 2014 at 02:11:07PM +0900, SeongJae Park wrote:
> da9055_regulator_dt_init does not declare return type and it cause
> following build warning.

Applied, thanks.

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+2GLAAoJELSic+t+oim9qEAQAJup0cSsX6AELdyngcYVAISa
t/P/982CprYPg+QSss6+W/QywTVzdWAwyIQtWvu5Wp1eV8e4nrC1JmCxIbAtnFDg
mrh0xOdxS/6IJGJOE8OmAcqQUniQnfGZ+AeKhAw1oT3Ii7BBOUE0B2RdEblEqNcO
Dh5pOexhxllWeldk1ltuGqlL/rjEdS0AO5KBX4ChX++tK5mWufsxQrRjhux+ryKv
ajVKC6RKL2IpDAm/ae4gp9BNiDCherqj1WSvFQ8Z5vs30kSryTy2Dv6jMmf9At8i
wCIQz/B7DP46rZbTcM+mw6lWuTUAScdsPV81VgvWZXcSVG3zTpiDYEBYzrACH2LG
ZfK4aiMQJe0NUhFmwIfhYXLvLEZTv0cy36xW2O5JdVJZUE4Ps4a+UcvjXjJI9r1x
H3w3/1vOVCMNNuuRMiIMT9jlQU78LLW/cOp1w8uXQmBVzd/rhyjfPbI/e72xcBV4
WfEuxSjFgPhT61s2JvhLfpljyoWwmkci5kojMak6C7g7cKHo4YJglzn08fnmIlSZ
kmErjVN+rws/fv4Y1uULEK4ArY3VSW7XbieX3xIgHz01XySMLjfZHYtfNC6PkFCC
9Vtz5JBi2LWrd3dxad7n7TGtPvN6K/KbX1L7pZEv5RFP1mDmX2v9fHRyu50nhVp5
/wnilvKlv3le7vGYVMmo
=5pdp
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
