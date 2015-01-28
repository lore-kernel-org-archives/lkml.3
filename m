Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbbA2B5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:57:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:50415 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbbA2B5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:57:13 -0500
Date: Wed, 28 Jan 2015 15:08:47 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] power_supply: 88pm860x: Fix leaked power supply on probe
 fail
Message-ID: <20150128140847.GA25198@earth.universe>
References: <1422373914-17235-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <1422373914-17235-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 27, 2015 at 04:51:54PM +0100, Krzysztof Kozlowski wrote:
> Driver forgot to unregister power supply if request_threaded_irq()
> failed in probe(). In such case the memory associated with power supply
> leaked.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: a830d28b48bf ("power_supply: Enable battery-charger for 88pm860x")
> Cc: <stable@vger.kernel.org>

Thanks, applied.

-- Sebastian

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUyO1sAAoJENju1/PIO/qaowEP/1aN/7qYkPN0Ju6phNSDtrv8
vQNesaKUI09Trd6+ELM+RBQQPfgH5OENkyIK42BFfq6BXIaT6rzc0o/J6e6i8X+7
HDyNqOxDruBzGetSfHVhcRWphHhVpOoQMpQvFLpftL4SsoiI0HjhHkunT/A7qY3L
KjN8qIafCHeg92dBdnXvf5jAi8MAKevezmzh8tBL8iPBNOg+4rWp51AsTh76JMTl
g4PRJiVeJbAlZqfY8FhsAEigx+Q83AZPITSyQIx41xhT1P7Eim0Y+gptPbWK/Zgc
Tehx4/3pc8frfBeEsbtPWr/QpXsGFI6+XvzCVkVUGsdFdDHXVrYe984oyPWWfSxw
Vqeq8mcZJrWYh7TXjzDINDCjY0ZATEZXxdqvPPFliSREyf9Rgc1iJ6/JgPGgoLEy
bNouvtM/w9OAK/R3uV6imoQj9UijLyi1/kGUs5diewCHumJGFGbV3UMqafjlyCI1
N9ZBJNy3M1wgasfn2e1/VGjZ3n6zMI2tMQ/xAV+roFtYAaV2Tskpm+hbqEkW6ZXN
glyoRCMgvrwmqdWcBaHkXmLE40IRYJGvtAbrS9Awc66fw+HqIzT3137ZLmz+4zD+
dZgWan5ykGNA4e4QJHgjAzyvRAOgPG2zOn2kOpWZHdP8YcSKTkgfYT+d8Fhyz8NM
dIeWCaIE6Y6XtCWqOqIt
=VNMX
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
