Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaEASqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:46:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54292 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEASqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:46:10 -0400
Date: Thu, 1 May 2014 10:59:17 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org
Message-ID: <20140501175917.GL3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-7-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pfJPkqu8nAxkAh8+"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-7-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/15] ASoC: RX-51 audio needs I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pfJPkqu8nAxkAh8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:27PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The codec requires I2C to be enabled, so any other option
> that selects it should also depend on I2C.

Applied, thanks.

--pfJPkqu8nAxkAh8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYotyAAoJELSic+t+oim9uIoP/RdgurA7tqn/5Cw6anqMJW0z
fowGPmXMbEeJNDA8ofuMC/rdUDfWn1Bm6LlVbOtdAznviy976qLbwldharT7DAR9
rnFs+ybeO8lu6PRMvFD6eJCHZpgUtmHecqOwmyhSlynqHVBvhqwzM3/rrLfUZ5pT
ZdCWg8RxCx3NY5yT+Msc5S+2KCJOFv2uNR4tbRcSJkavKuq7o8uzlFI2aYCQEGG+
lCf/iV0TgT2IYtwgjAamJxNg5J2a7Tl08tmWAms4nwUVNs6whZHaOMlNeyjnSJFn
uyyGTqbdsfq8qNvcH1VaJf8Rk/WIDiuTFCtjKyZHoT+5cAH3F9gQ0ghiS7ZE8N7L
qFEyoZ3WyDLH7/xHbkeCe8dXiWlxeV8qH2dWtOxowRnujyePLzLAJBAFLsbToSxT
ITb4q9m6d8xRsHVmKxn0OGFze7RFoH1oszS1QK4CeMeLvKYD7C0Uk8WpyrdULs5D
Y2kvkOhRwc44eG/bB8gn+MSpgxsXDkuKyWMQq5GQARYKmc2kGHWaOCfXr4BUWwo3
+w9iKVHgZCZsgUPEG7Kya0P10FbHIvCWlqPJ8DQExdCJEA23ikh/e1RqO7UwSSUZ
ljyBnlxcnEmGQa+RtFm3at23VFK6mxJrQYoB0S/GzINic97tc5OdSnicCZ7F9FLT
N4dwXoaJyJFp71w5AaKg
=wpNX
-----END PGP SIGNATURE-----

--pfJPkqu8nAxkAh8+--
