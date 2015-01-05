Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbbAEULq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:11:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36744 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbbAEULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:11:45 -0500
Date: Mon, 5 Jan 2015 20:11:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20150105201141.GK2634@sirena.org.uk>
References: <1420448821-9942-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45wMVEkw4XUbiYON"
Content-Disposition: inline
In-Reply-To: <1420448821-9942-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: meson: Constify struct regmap_config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45wMVEkw4XUbiYON
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 10:07:01AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.

Applied, thanks.

--45wMVEkw4XUbiYON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqu/8AAoJECTWi3JdVIfQVw8H/1QYQCphSwMTJFrYStcURBiH
p16kJAUTOCPSGOwFuP4VkRXqhlegjGkiOzHYsUh9sKb8SE83JJu2EBEwefLzsk2r
U4d0geYs1Tfv1rCcfxr5eWLsO2Qn6eBZPSUSmhbGiwTUf3adyPJBUzMSyC4YYrWI
zuuRJKd4vH5ktwf9SBSUENLdfgVq/816+nLMOx8GsPiODZ7I4VANYjX2aglylWPS
i4zzPsDJDibxbnCVGxQRzzIdvXoW+QX7HHI9VpaZ/9ejv9z7Muyex/Zsd+gOnitr
6vBxXCwnsQ3gpTZ0aOu+NuZBkOg8lrDhRduf/y9h06HP+yY4PUDsWFVuO0K/mUI=
=PoJS
-----END PGP SIGNATURE-----

--45wMVEkw4XUbiYON--
