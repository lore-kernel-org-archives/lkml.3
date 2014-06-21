Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbaFUKdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:33:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51827 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaFUKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:33:54 -0400
Date: Sat, 21 Jun 2014 11:33:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, spk.linux@gmail.com,
        p.zabel@pengutronix.de
Message-ID: <20140621103335.GV5099@sirena.org.uk>
References: <1402382093-27338-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UDXac3CCxvoffKng"
Content-Disposition: inline
In-Reply-To: <1402382093-27338-1-git-send-email-sachin.kamat@samsung.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: ltc3589: Staticize ltc3589_reg_defaults
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UDXac3CCxvoffKng
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 12:04:53PM +0530, Sachin Kamat wrote:
> 'ltc3589_reg_defaults' is local to this file. Make it static.

Applied, thanks.

--UDXac3CCxvoffKng
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpV98AAoJELSic+t+oim9upEP/2iUnbnEKqEIDbxxjPi21xI9
1xlewpBvhg+bAsKqAEUOOUXrFpdbUgexdZx2L+vTnV+Syh4NLE2R1KLIsMYagRK/
+ahS2MlwNn3Mhl3tXRzVX8M5hoAxQgLLAycuJEyelDD8otcKxi1/NM80VdLWARFl
j9iQH2DO97uzY1n4vwKX/5MSX3up/RTVJt+MnWC18JMEVA/tU8WIzPCfTfkUk0Dv
EQ9JxaRNt077IzU5QDRxHgdh7GbuZN6/Vt/YpeiqFU+0ngMFDZTtJKRyF5hzVRR9
bhclyaf0GDi6BkMR3760kvN8Y/xb658rq2IbazfsRutKaIBwiuNERoo4/Iykb8W8
JzJ6JvtwE9uEFFZYxtGZh6aViv8E4VSXwVPAiR9HyjlzEeMZvWYgUWQnl98mriLO
KLk+Mq1dmRHrNKIcMfPhrljsGS02KyiloEI0uBFcbT38QY/un00rxTvKwK6UXItY
/Y+1Z4W1FXYMUR5LTNJBz1uE5nhlag+d8TpO5F/ID2J3pKcZlI/E4+U3n4gPIlef
Bhh1d6rExlYNA3zNwkskHr4qLNa37AQI3UwsnXJ/onIsfOso5xFnjrdNmSFxC5ic
HULDzk8med2Ji8Axy+VhBVRl3hZ+9isqUC/mzTJX2mV4h1gbTwt3kt4Z2AehG8nb
nxxpkO/Y7fRa5cSHTbyR
=X9lG
-----END PGP SIGNATURE-----

--UDXac3CCxvoffKng--
