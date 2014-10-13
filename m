Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaJMKtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:49:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50223 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaJMKtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:49:14 -0400
Date: Mon, 13 Oct 2014 12:48:55 +0200
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Message-ID: <20141013104855.GO27755@sirena.org.uk>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b1CVx77D595wdcW8"
Content-Disposition: inline
In-Reply-To: <1412845377-17134-5-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/6] regmap: cache: speed regcache_hw_init() up.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b1CVx77D595wdcW8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 05:02:55PM +0800, Xiubo Li wrote:
> This may speed regcache_hw_init() up for some cases that there
> has volatile registers.

Applied, thanks.

--b1CVx77D595wdcW8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO64WAAoJECTWi3JdVIfQPIoH/Rcocr2/L2LHDi+r/5w4+O6l
uAbKVwZU+crTrjPgso8ZN//eU8j9FHRRCqYLXUDypaRCA2/L+ZBjAQD1WknBXNS1
8TjQPtYgjLAsWQ4Psnqm2TWcxyaoJS+5L6lRvRW1l8q7wziOVql+IIHNYAYQwMyb
INX3v1aMiygmIyf4i1Fyqdx8VrxUvE6GwBXcmTqKjxvt+lEJXP7Y5GBVDaynUUL8
oIKjpr8UuNEEIOSFP9koMyZHf7qTn7O0bQOZ59zJhzllS81T3DJEY1RViuOSlIGY
aJaqeQfUFE04mfT4d4gFJRZOAfwyj6MtbL0q1MeUpgk+Pj1r1jEycbktt4xkVWQ=
=lb7C
-----END PGP SIGNATURE-----

--b1CVx77D595wdcW8--
