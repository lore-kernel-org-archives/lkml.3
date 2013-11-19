Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3KSBto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:49:44 -0500
Received: from ring0.de ([91.143.88.219]:47139 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab3KSBtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:49:42 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 19 Nov 2013 02:49:38 +0100
From: Sebastian Reichel <sre@debian.org>
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Grant Likely <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH v2] itg3200: add dt support.
Message-ID: <20131119014938.GA20782@earth.universe>
Mail-Followup-To: NeilBrown <neilb@suse.de>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
	Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
References: <20131119113013.39dae3cd@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20131119113013.39dae3cd@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Nov 19, 2013 at 11:30:13AM +1100, NeilBrown wrote:
> No new configuration, just a 'compatible' string and
> documentation.

itg3200 looks like a candidate for the list of trivial i2c
devices [0] to me.

[0] Documentation/devicetree/bindings/i2c/trivial-devices.txt

-- Sebastian

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSisOyAAoJENju1/PIO/qac5cP/iCPHuNN8ht8/7Iezs6XWBis
qXaWY64apj93jpbXAsMtjQB4A8QcboJEvLAZeZycOC4h4C36VtWpe7iOM/j0Ty83
rgMtOVhU88s7QSigk1DUymG4gcudm7qX+iRCdmHP4YVtesY1uGELKWPKnnrkTmpW
T0wYC05zg2ENiGcBdz0+gb2Xj2wG9LMcV7cHJjoRIWSLiNCN3Zu3OJR/adhdJjv3
ggtA+pqAwoBn73JwGMooE6u6nhX3jzgEJU+J8uu+VLcuUTL544pBJpPw6VJBFjVp
AQFH8JnF5Ykpi4XgVYnc12QuhDroLJk6xbaQNq4s/NvSaGj6mMBxdTT6SqKR4+AC
tgCcbsPcp6sbrkHZ0S9rZbMefwbtArrnKGb2SBd3abnshPRPRsk3paVfJ3tx198w
OvTiJeUCNgrHHRdpeoCRy8B5nS1KMOvV7QnaSHX70vyBXJkSqdD14TIx+MjY43QN
61Y/7/AEWmhEfAIyCnpFlFwI4v8JIPFmUg26GAyFgGqbRvSRkPCIFEjjFkqr46qW
I01R715BEjDjZ9ZFwGoWZHDc6sFbhTeScmp4yHpOVIYExRCWIs+NQs1gTEfBGhgi
lDW4qKM0DMDH6ExXhkUqI/c+iLLw7JMefFSLI8qE0/xiakOnmTV4ZgDVobghTqJQ
Szg0wyj+eWPUeqAp0jRh
=aIxF
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
