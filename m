Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaIOVuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:50:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43592 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbaIOVuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:50:22 -0400
Date: Mon, 15 Sep 2014 14:49:48 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140915214947.GA7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
 <1410722585-13393-2-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zDL9gdIhmXu2QQXr"
Content-Disposition: inline
In-Reply-To: <1410722585-13393-2-git-send-email-heiko@sntech.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: fan53555: enable vin supply
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zDL9gdIhmXu2QQXr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 14, 2014 at 09:23:01PM +0200, Heiko Stuebner wrote:
> The regulator can be supplied by a parent regulator through its vin pin,
> so add the supply_name for it.

Applied, thanks.

--zDL9gdIhmXu2QQXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF177AAoJECTWi3JdVIfQZWIIAIBiCulwAnfTJIdtnVlGMBcR
R5NjsFiGrqfOkq34aBj7uZ5t1MjxO/3avKvFSzffgh0sfUyiazNlhfQNTnAWpxFg
IyTeKTtfTiIp8ZZgg9c9c4epVm+BcIS5XHOUvJqX1+pfpGJLVzonDa6haTDgk79z
ZwsvOiX+GoqF4cz/4fIRB7iKC/WqyY9VgkQvvWc5wLF24D7zrPD27Kf7QIygmMCC
KjaCcls90BgfZ0UWGEDKgiRbALylN4w+ZSVKcPssFYmYbumIybbhZNjakl4PwPcm
+G00rZF85dkRlmzYwdoeyM+yqEJkb5+L0uDIUa4P4AKfLIgrnMNkwFAh/fT7chg=
=b0sN
-----END PGP SIGNATURE-----

--zDL9gdIhmXu2QQXr--
