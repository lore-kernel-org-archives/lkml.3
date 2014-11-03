Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaKCOhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:37:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35519 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaKCOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:37:29 -0500
Date: Mon, 3 Nov 2014 14:36:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-ID: <20141103143613.GO3815@sirena.org.uk>
References: <1415023625-17921-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRo3kt64Wi40AlcO"
Content-Disposition: inline
In-Reply-To: <1415023625-17921-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77693: Fix use of uninitialized regulator
 config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRo3kt64Wi40AlcO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 03:07:05PM +0100, Krzysztof Kozlowski wrote:
> Driver allocated on stack struct regulator_config but didn't initialize
> it fully. Few fields (driver_data, ena_gpio) were left untouched. This
> lead to using random ena_gpio values as GPIOs for max77693 regulators.

Applied, thanks.

--QRo3kt64Wi40AlcO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV5LcAAoJECTWi3JdVIfQCc4H/33bqo7tOXkiM85rEJp/Ssw8
xxEDuBO7bkfQITDeMhsgzLK5KLuf/6WMJ1T7EgsO34XQ+UhKTeTqLifY+BgPVOwh
HfeVJ6cx6IMrkcRXgw6Z0Tf0LS++FYc9oyUueYWiEP3Me7ah6+dJ6IhFoSbgBFMi
okoswOZ2h134R9huFuAELwVEBGgROVIdaX3RcanGoePFi8QEhAuuhNkTJz/3u4Bo
iV+zboJBRYBd6+owHbtw22g8z1qPR7+MqdnPkjUofFwCgfDIeWdivkCOXs+n7TAg
Ty0Q3RJ/hhorJBXc5f34zx17F54ZAny2ZHXplVJ+ccqp7mR1kxtxd6Fv4asbQeI=
=l+21
-----END PGP SIGNATURE-----

--QRo3kt64Wi40AlcO--
