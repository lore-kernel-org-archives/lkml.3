Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaBTNSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:18:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47440 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaBTNSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:18:37 -0500
Date: Thu, 20 Feb 2014 22:17:45 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Message-ID: <20140220131744.GR2669@sirena.org.uk>
References: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
 <1392894472-11956-3-git-send-email-mpa@pengutronix.de>
 <20140220125130.GQ2669@sirena.org.uk>
 <20140220130108.GD21048@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3FmRlnZT3MJ0iQxE"
Content-Disposition: inline
In-Reply-To: <20140220130108.GD21048@pengutronix.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: core: Replace direct ops->disable usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3FmRlnZT3MJ0iQxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:01:08PM +0100, Markus Pargmann wrote:

> I am using this function from _regulator_force_disable(), which calls
> _notifier_call_chain() with one additional flag
> "REGULATOR_EVENT_FORCE_DISABLE". To prevent calling
> _notifier_call_chain() twice for the force_disable case, I moved that
> function call out of _regulator_do_disable().

OK, put that in the changelog please.

--3FmRlnZT3MJ0iQxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBgB1AAoJELSic+t+oim9IaAP/03K9n/F3VLTO6wORyzmcD4G
kWSWEHJJJVDJFwtXBshNjYW/n+zvdw4YDcE5eiQixO6s5OLJbMMfIJGtJopW/Km1
xevYoQ7iWRaNqWtsQCTlc+0o3GlxqMYL0qHlU3oNtHUQnnNnguq7ZYYwaYkA73Vi
R+yHl5HIcz9MPRr4YRtJXAf7tMnIV+8pzXrGW91tjtg1W3yBleHqv1UyiAc0jUCe
zGIGaT9mbZe3EpyL8DDpTo7mP9F6OvDXHb89w7vvD9cTlnunZIK4VkGL52GCWM40
6jAq3n3w5QFlyAM+b1dSQQ4bGkbJWR72FTnUI6rMBocQ6ffpQFc/tEpZwEA7oKg9
5sQ1VQ95Bxjqp8izlHvpdLEcS51WN5VHeLN1GLDYKRoztT1PQWqbmkMXDnmR9vQn
iD3Fn66tA3uriXWr4QwkYalPRnjUoNOd236/hxNGqXgwlgM3+pELCaCQ76zfYopH
dZ6FEDITLkagD1V38bkQdyN4aqGFWbTh1Ca+aGqlD42SYTgOK0+eGJUsA8gf+ZAY
LtDl6/sVqDu8BXr2GLa6pxa+n+6MzvuKMRT4XPh4UQnyCUCV/J5Qjr/Qb9OXeDGR
wQGMKHIx+WqWOtfBVHj/3be5GmLFrcAg7FZmfRGyPZRskCbUzRR+unGP7EH95IIc
1DjYLrhnJYOReesmbrVV
=TK5Q
-----END PGP SIGNATURE-----

--3FmRlnZT3MJ0iQxE--
