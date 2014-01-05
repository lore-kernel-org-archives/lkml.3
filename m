Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaAEDvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 22:51:03 -0500
Received: from ring0.de ([91.143.88.219]:44315 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaAEDvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 22:51:00 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 5 Jan 2014 04:50:36 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/2] twl4030-keypad DT binding
Message-ID: <20140105035032.GB17291@earth.universe>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1385830416-12900-1-git-send-email-sre@debian.org>
 <20140104054006.GA23424@earth.universe>
 <20140104084901.GA1991@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20140104084901.GA1991@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 04, 2014 at 12:49:01AM -0800, Dmitry Torokhov wrote:
> On Sat, Jan 04, 2014 at 06:40:06AM +0100, Sebastian Reichel wrote:
> > What's the status of this patch? Can you queue this for 3.14?
>=20
> I just queued it.

Thanks.

-- Sebastian

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSyNaIAAoJENju1/PIO/qaH6wQAIkdB/qxK25N42E4d38hOSoh
wMecH85OVStbFMA4jyN9+KeY1egiHbLr9MPnvqW1YmBdjM4RPjsI6kUIlHKasPS6
hUhMc0+BmJJmwuRD782JgM/7hkLgLCrdv/YBV7hbeMzoP9Tbh4D+/HS/8hjc4NIE
18OZYLuqLFIIa1eEDgjcdQW/DpK1RLGgrotIFY7dCj2uJmWWMwWzYBNBl25fhq27
PISzFRYhewXf0kjAE3UKJogfnutKV8pPjfUD+NU6GUpdJCMNfAlRSioxeBnU98+i
LDk/STSdDmmga4pmpr+lsqORg6wX0xVQo+tRrpNBnk6QN2r+CJL0tlDhH0NeV82u
e5Tgwgiaeyqc3YZP8P2vIlheF95Y5TZq1TaiZub9lzH2LvnNLlYAedqrw3eWDSjT
UAkjPBPjZ7Z0s8RSoBk5JXqncRBsZXh9hO9oGq88rngjmrFoXfRnATp0n2Qp+dBK
sg0grd990Dof4xPaKhcPjSEQ51d4dl6+HbUNYfEur9xMVhkDgi+3aLLnv4CduSkd
UdGv6sWKcHjS0wbCI/D+LJEO7LopYrKekVMo63qXQALyjQ8CUkzEjUQaFbafSNxR
h7LEGLr4LwjuoO27JNOn0RNGMLgl+fe2Yc9b3LUd7DAvevhTKoPT9cJjb3ItjOR8
TIHdJn3XRxz4miBWWxWw
=Ykwv
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
