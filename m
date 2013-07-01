Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3GAKQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:16:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37883 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3GAKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:16:38 -0400
Date: Mon, 1 Jul 2013 11:16:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130701101633.GE27646@sirena.org.uk>
References: <1372523632.5891.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/oilIk/RGk+ZuCFG"
Content-Disposition: inline
In-Reply-To: <1372523632.5891.5.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77693: Remove NULL test for
 rmatch[i].init_data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/oilIk/RGk+ZuCFG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 30, 2013 at 12:33:52AM +0800, Axel Lin wrote:
> The implementation in of_regulator_match() already ensures match->init_data is
> not NULL for all matched cases if the return value of of_regulator_match() > 0.

Applied, thanks.

--/oilIk/RGk+ZuCFG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0Vb+AAoJELSic+t+oim9pE4P/33boVaPmGFV3L1Ai5xEz5Zy
uGjCYvreDdez9GRgFyH/TII/7IFaa0P0H6X5DgrYMyv/U68m9tk6rgOmeDa5CbiJ
Uy17UYgc06mCwbEzEjBKH/bID9a3PwKwOIn7HAWwxtTnNgwHyL5neyd8peO3mpeM
LSGIgazeKGBtQ6fJYkKPxSw7tuWxV/c2RYNRHj+xUq9q1Hur7ao8RoA6iiwBwD2h
jszvYcU7Jnc2w+jz21QIfl49TAv4dBEsLxaK+PBcCeEX1HzINmtabx+MJsDh2rz5
/UapfdctKUW/8Fk3pIYNABZUMRfBkCvABiqXashfS+Mh/NFskjxR1eIVCUa9U3W3
DAje7hF8CUI+3hdiBn3RnIsLP/3pBFivjLQN0aKidXoOLui/18lpxjKP/i3bXFuJ
bBlebYGZafMNU+VQVqdzg4Kkp7qfhpSw5Ea75ruYL1rCnwPSmBRedWijEcLiiGQw
9Hy50//fcdiL36EngOfpk2bwpo5RYq6D+wdE8tUXaryUZLI+rpRmwRmF9N2wiY9o
fyHFyPBPO6GRHWc9DylzzTLHoAYzBeiZ357y7DV/fgQryDcFLk9RYaHtjvNOZMZy
xgvMYBL1zllEFyW6lfZ6xrWdNZULnF47nc892xNNSU+Pgq/WTugcmiLrKr7JiYSl
4qmxTvJjdzQH0Bm9kJSI
=ZncQ
-----END PGP SIGNATURE-----

--/oilIk/RGk+ZuCFG--
