Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3KSOoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:44:25 -0500
Received: from ring0.de ([91.143.88.219]:49915 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab3KSOoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:44:21 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 19 Nov 2013 15:44:09 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
Subject: Re: [PATCH v2 0/3] Add support for charging battery in Nokia RX-51
Message-ID: <20131119144407.GB28455@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Anton Vorontsov <anton@enomsg.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pali,

On Tue, Nov 19, 2013 at 11:18:02AM +0100, Pali Roh=E1r wrote:
> This patch series finally bringing support for charging battery on
> Nokia N900 (RX-51) without any proprietary Nokia bits in userspace.

YAY! :)

> I removed hook function from bq2415x_charger driver and replaced it
> by Jenny TC power_supply notifier code. This simplify usage of
> bq2415x driver and also allow adding DT support in future because
> driver does not need board specific function anymore (only static data).
>=20
> I tested this series with linux 3.12-rc5 on Nokia N900.

cool :)

Do you want me to take this up and add DT support?

-- Sebastian

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSi3k3AAoJENju1/PIO/qaStcQAJkFlzEmn4jPWBnFGzEDpO8/
FAk0ZN+Xh5k5anYQhNoFNvfvqCyPEoaxak7BdsPhZZZRZeXnjTqyr/ExEtxppGNo
GVA9Dk1UNSx5nCxsUVOL6cC9pFEpzycXm7k1SXxbaNG2Kc9WY0m3/CKAjuyI7ahl
8v/9rQvFggA3SOHj+RISq0Ay6Imlc1zT24zDsIWIqh0F++IvR1/IS9HYy0CBZKdT
TG/dOX3tqnBj2T0QcVRAv2blMBofPcRNU9TK1DZJnITSaowbm1FSjPKN1PFsxT19
lRrRGQ/+RJ1Ylnpb1FmbPS1GxtWtZgB0Nb3Sy/Xz9gND+1w/P5KII5tKfKaImPIL
3fNCjL/qPunMprk4Yyr2IFLZLHro3XwFpmX8zeUN7qZ/AFfC8YzUqqe7iwoKkBRo
XnfrwMb0yEA7y83PXsi0hEaBhw5A4bC5u0GxfbbKQ3LhqROmaGvV/ZVFIiVEZ+28
oGD5Q4YuRJmiNYxjsv7fKBiMf6BXJ78zhD6jw9Q/gI7xCx44LVgd+3DkGEZdSt18
mUmRT7ayni2CwsDe2CZ9zmg5NHoJqp/pFkn3DhkSGDiy9s3OSlzjXcyFSEjeA7cV
Hzf8vHyrkRSGSBg9DcLlts0Kisyk80gLZ2LCf2cEXM4LNoV/HItd3b0KjWwkWH0+
KIPJvPfMifjv/zV1GPQZ
=aPeq
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
