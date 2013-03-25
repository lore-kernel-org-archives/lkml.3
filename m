Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3CYKUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:20:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39050 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab3CYKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:20:36 -0400
Date: Mon, 25 Mar 2013 10:20:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: ab8500: Fix build error
Message-ID: <20130325102030.GK18316@opensource.wolfsonmicro.com>
References: <1364194430.25717.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HmK7y6O+lKZIGkr"
Content-Disposition: inline
In-Reply-To: <1364194430.25717.1.camel@phoenix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HmK7y6O+lKZIGkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 25, 2013 at 02:53:50PM +0800, Axel Lin wrote:
> Fix below build error:

Applied both, thanks.

--+HmK7y6O+lKZIGkr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUCTnAAoJELSic+t+oim9KJ8P/jxapE3k1Am6hcL8Y7Wq5U51
9P9Eb+za+NJVZScboaSB2GpWEBLISR/2lN5gokzjNpAdlx4SO/oFBmJaapPl4Rxy
WEqknW2GlPMmVgANXvqCg7Bfft9o990PdBaoz7yYNv7ItZEQfxodxh/gcryPrJcJ
f9MsKUzJerID9EcOg48p8LBfWaYaFGxWPePe+6MPE1T+5kPuo6kEmWB7N2WZR5fQ
mPvZfL2raPJjRqUQSyLlVnxKm3Q/k7lulsZ2B/yc6gPcQIGlip+PwxYu6fyxK4a1
NL+RfJrthGL0l2FEo1FsjWYihbpYz8cNxlXlIpsS5XN3LDUAd3NhARqfedhODomR
VI7yc66gycoWaaQ2JFMduPPqLFu/MgomxpwS6B+CNj/I6aDnIkF+gesjzOhYp1Mh
oayhJWBgAv6UhvHcxdcAerhXAQYNh4rTOXJJkJlvjJjk98K6bIYAXkol9930VblA
x04yf/+p9pAr/BqhpN01x3ptt159hD5G+WKeG3tbf7PSvfXQrx9opkKe1R1ZKBos
krvKClVCiYpjEwvrkK70x8RS7BNZmr0gHAk8grI3MEZjXk3ED+nUcba/X5EWDMYD
MeaterlRs7gmMps42zgiLl8PBdTPg2IhdgEJmYeQFDQWVZFR0qb6DDfMO+lS9bFE
yFF5Zm6llNGtTj3A5o70
=2Wwb
-----END PGP SIGNATURE-----

--+HmK7y6O+lKZIGkr--
