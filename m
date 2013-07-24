Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3GXO3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:29:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33192 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3GXO3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:29:45 -0400
Date: Wed, 24 Jul 2013 15:29:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Message-ID: <20130724142940.GC9858@sirena.org.uk>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-18-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCKTTGDksHH4MFjj"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-18-git-send-email-wsa@the-dreams.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 17/27] drivers/spi: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCKTTGDksHH4MFjj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 08:01:50PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Applied, thanks.  With all these it'd be good to have subject lines
matching up with the standards for the subsystem.

--bCKTTGDksHH4MFjj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+TRAAoJELSic+t+oim9m34P/jVTjeoy3v9G0VkCUz2UceAC
oUBeqfi9mKVgCLo1AJZ4rTyAuy0unMaW8Tury9VAXdXBDSnKIrY720dNujpC+Ioo
d7d1ql5c7OFo7LV/XP9kvnij/9sKj71xT830qWTH2+SvnGnfXv1ZDm/rBUOxMCYq
SEFO7YDLuqZcw4DCx+SI+3VVfLV6oRqCV2sfoy55ib98JDwoQayqpnCWmWxmxHmi
RfVHOwAj5EfrjRoSUZ5aUPYu8xrdhJSrAIUjmjixNtp3hxgYG6e9M6MIDmf4fHem
8vqNnQ26NAYb6+XSnJF9pNU8GNRYYh79Xq9QiyQ2xA3aspkYyQXQI8nQfgTugA0x
Vog5XwtYpmXN6UIdBbiQ6NJxrDU06SIXZjOTGdbaLDzHo6NG7j0fvLDkvqnz2R3A
J6+6pnlFlvG0CqQ+6y4O6uzS6D1cutbEHpIu0FStdldATk1vwBD3RUFnMGfTRlKw
vSKLG925u6FwLW9LW3X9bpcNPcDzyY7/gWCUX/k+J8e6UauVvpu7S+llkYXTDMuX
0AfEDyaWLgyvdaSWeNtuyvXSsTUoFWNEUC/7KvQWuezBOA0+ZDC5JJ9PqdS4pLXL
OMFybOae9whcxkp+Q266+xVeWZ+F0+/rxqL4aO7C7x3VgJL7x+qsuiD6BzmfpfNY
4GMPyxXxZtSwocTwwtJo
=wD+M
-----END PGP SIGNATURE-----

--bCKTTGDksHH4MFjj--
