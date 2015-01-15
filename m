Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbbAOAxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:53:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:46048 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbbAOAxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:53:03 -0500
Date: Thu, 15 Jan 2015 01:52:49 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?iso-8859-1?Q?Ren=E9?= Moll <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND 00/13] ltc2952 modernization and new functionality
Message-ID: <20150115005249.GA20141@earth.universe>
References: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 14, 2015 at 09:15:33AM +0100, Frans Klaver wrote:
> Here's a resend of an earlier cleanup and improvement series for
> the ltc2952 driver.
>=20
> This series implements devm_* usage, reduction of globals, some
> cleanup and finally makes the input trigger optional.
>=20
> From the changes to the previous submissions I did not include
> renaming kill to poweroff. The name poweroff is already used a
> lot. Besides that, the control is referred to as kill in the
> ltc2952 datasheet.

Thanks for the cleanup, applied:

http://git.infradead.org/battery-2.6.git/commit/d84ba07c27fafca3cc77b25a1e2=
04383a4b5af91

-- Sebastian

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUtw9eAAoJENju1/PIO/qatb8P/3bKXUeBEJ6n6pixVf8aTdGh
BpVzDkCa4ezxb2esvDxT0YKWcquVV68bXlpYwnU5C324emSmgxY+EN8RyzQTO4FH
M5mESt6eTnZBwx87RNUD59kEyaKiKaxH2F3p+BNdv1ikSLiHYmvNGXyw6NoabNxE
TGKawixtJwfA0Y9VRHUqSIvrZfPAAV7x2N3qX1PMTEVBRttAunAMLNlOQ8rQsWel
2qtDatDqvPwJ/FQQnDmdd1ExRXEokvYQyFYS9qLoqyayioFeroZpBlnMOr091bJP
+OTwPi7c/z8iZuJtbYcvMsu3y5TAUNjM1E1vAH3gO4H81tKQPuPZ2jK8NJ2mLvYl
W+WnbfbuL2rmZlOqErhXhOLCrRWwn1rkVrO/ITmXGlvdr5CMIYmzQNBeSsQnl6VJ
QUyLfupWFW2xK/exZKLPvy8+orFBlk9JhZyF3SVzis1Hr0Rw1CbyBd+9SmPTtP6U
KIrtzE7+CLtsp8OLiZW+yNz++d7CBXx77DebRHa+hGX80FFAL8VYIeJhlRSS53Fc
tRl8BiyEVpRjRS5blJAqOEUR2ZM2U8Xl/dUYqiE2oyCig/xcjQx0iIxjQXeCWUZQ
iwzw5nlGLMjiLYCm1PNiEyxAUwdRfObIGeCoNc0zoccgFqBXzW4rbV1jBw6E8Nxl
lwWRJ8d7S27+zTE+aSSg
=8HFH
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
