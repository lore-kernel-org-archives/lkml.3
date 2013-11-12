Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3KLPbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:31:17 -0500
Received: from ring0.de ([91.143.88.219]:46426 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab3KLPbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:31:13 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 12 Nov 2013 16:30:57 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131112153057.GA9683@earth.universe>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Nov 12, 2013 at 03:13:38PM +0100, Linus Walleij wrote:
> +	plat->no_autorepeat = of_property_read_bool(np, "linux,no-autorepeat");
> +	plat->enable_wakeup = of_property_read_bool(np, "linux,wakeup");

There is currently discussion going on for the property name of
autorepeat:

https://lkml.org/lkml/2013/11/11/680

-- Sebastian

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSgkmwAAoJENju1/PIO/qa5MkQAJ0tXLRMZ+AnZ7K7NDkK7cQa
De6wGZJzA7wu07NqrZ4nwXR5uuDP54jASK8lLkIqV/sL4gUvCEj+54JcB2UB5jYC
TS87JOAhafrvd9E8gxv4kIZ1aTMRMUs+yr7Fo1WDRaaVfEzu7Ktvtia+AyqrI8zZ
eFqk4OqdEDxZKW/LM0ywPvxTNWpPiEP2zpCqVXTgyZ9gB1ATfXq9+FZHemHl4h8n
s4kyuJdtUlq0m43zvQQvrCyLeP0/oguKKNeAyeMFMIK7GMU/ruI0dKWPWV/mGh9x
XpQQMTt0fT4dhJmLoOk/IutZtyzoZ++BSPyrEm0PRON7yf60lbMjozDcLl0wen85
Ypg6P++zUslArSBptlXP1IZojNnOKBJYa3oDQwbvXnnYl9muKEVdRb20omvdENsK
ga85OYQfsiETLcyfNsvAw+lA0f388Rnfghc89239krDGJZRibr50aVBtwwWMXfLg
APofa0YT6jdAFKaP9g1n3afVzfJmlEvdJQZAvpFqduFadMhsNp5YPwfzDiqNfNJH
E3K1DWdJ45JDBXAufcxPUIXpNIEisG9SBWxFWGjbR8v8KNbSgz6ndjfXheh3c09J
8hdEV4z8exkJU9dPuBDHF1vBS8EC2SXbxScoi7DgM9s1Pi/Mt9OTnEC05BC6tGju
Fac0okK4pFQrUHLlLRtD
=Fpzk
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
