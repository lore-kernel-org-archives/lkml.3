Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaAMMSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:18:04 -0500
Received: from sauhun.de ([89.238.76.85]:56279 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbaAMMSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:18:00 -0500
Date: Mon, 13 Jan 2014 13:17:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: i2c: Export single device registration method
Message-ID: <20140113121739.GA2586@katana>
References: <1383674240-29491-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1383674240-29491-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 05, 2013 at 07:57:20PM +0200, Pantelis Antoniou wrote:
> Dynamically inserting i2c client device nodes requires the use
> of a single device registration method. Rework and export it.
>=20
> Don't be put off by the weird patch format, it's a simple move
> of the operations applied on each device to a function.
>=20
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Are there public patches somewhere showing the use case of this patch?


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS09ljAAoJEBQN5MwUoCm2zlwQAISAufZKluvK9sZVurT7M0OR
vUVJPP37NWkKEF+zrqShHi4+x5xUHg0QiTMe57IJNu43b9stpyweCuKGseemx0EH
sISX1eUbf7WHvMCUt/i/t/33+PBXdpKCF4dMdtA7l3X3y8UzJFZYVU+BMgzCpWLe
35aRr3/0MSkZR/u8fSlqSX2hiWtpwH0NHNeJadA5QYkhTbrOUe33TGsxaFMGFIj6
dn9gFlYDiJvB5EDnAX6j9lKl07akhDL1Bw6ED3f39guLF74UHxkzCR+n0L/CCz1U
/TSaRRAZIlOM11wDwpUNzg6lXLq+xxgwZoWhgu+aSqRY5mBwsNc0lPHEV8c/i4L2
+MKq5MQkjHel0YE1O3F/cF1+AGZBZopjo7LjP8+QjQ9XJOD/TxLnkumhQf8M4pI4
nLvcDmDQK0kLDh1VHvUOq1aQtdXgpGjKq2Pv3afMAaaqa+t5g1EdubzHi3aQbySz
PrkmAM8J+2N6zIuIUbMjsLmV/KjPSE1QL8gOlV6U5s2KRyDW7gVf/z+IxcVeuFwu
HhLhNuL5zlKHUQUvXGl7uXQEbOjQH/3qDdzBbrPdT5EBvPNnZZ+kFMaRRGZ9gnLC
ldsmZiWWZR3UKKEuZt/hOdfOxntYlV67KY9TCzstT156aSxTdBtNi+C8LbUhPZ8v
y7MzdlZp7XpvIHU1nn05
=2C6c
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
