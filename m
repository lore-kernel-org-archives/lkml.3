Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaJ1WdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:33:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54024 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaJ1WdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:33:04 -0400
Date: Tue, 28 Oct 2014 22:32:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-ID: <20141028223223.GI18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i8OEs6gA6Pkg4k/n"
Content-Disposition: inline
In-Reply-To: <1414411911-5539-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/4] regulator: max77686: Replace hard-coded opmode
 values with defines
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i8OEs6gA6Pkg4k/n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 01:11:47PM +0100, Krzysztof Kozlowski wrote:
> Add defines for regulator operating modes which should be more readable,
> especially if one does not have Maxim 77686 datasheet.

Applied, thanks.

--i8OEs6gA6Pkg4k/n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUBl2AAoJECTWi3JdVIfQ53oH/iWkQ0Z5o7EH2lHWAmFKlZ7m
IB8eHWBZ6llptS1dezZhEaI7PSKS0t6AQK2sr0NuD2ii+fao6qGvHq1VIKKMZQhR
+w97NU/3aZ6uRv+clRnhh1o0hPMn/DOU6xHuz3/V0dUAbpn7fMGYWqnjwLbR+e8L
caM6HLmEeMA7Jh5cpNgtgO2OEThyZXibIGp6uiXn48I4oTr2vWZ2XJhunFUAYBI/
WdsR61aKxzmSXLrUfpE5+E/rWh8xygLHyuwZazxBRc94WjFRDUhU1EnuFTgr/DXf
iHYFg5nGzRwNbpbNut+61DKdPfQF3i8r2MCChMqQ2/5UOfxhgYP1heuedc7YRoI=
=rPsc
-----END PGP SIGNATURE-----

--i8OEs6gA6Pkg4k/n--
