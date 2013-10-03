Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3JCQrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:47:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49089 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3JCQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:47:20 -0400
Date: Thu, 3 Oct 2013 17:47:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131003164708.GC27287@sirena.org.uk>
References: <20130925144329.7d240a6fa2b5782dc8726340@canb.auug.org.au>
 <1380156448.17366.44.camel@joe-AO722>
 <20131003133051.GB25934@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="41bjdpi19TcwJlr2"
Content-Disposition: inline
In-Reply-To: <20131003133051.GB25934@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Sep 25
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--41bjdpi19TcwJlr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 09:30:51PM +0800, Fengguang Wu wrote:

> It's a good idea, unfortunately Stephen has already went to vocation.
> I could try the auto merge and merge-failure reports and hand the
> script over to Stephen when he is back. However the merge conflicts
> will have to be handled by the relevant developer/maintainers.

Well, Thierry and myself are running this at the minute by hand so
perhaps there's not that much need.  On the other hand doing the build
tests after each merge is rather resource intensive and that's where
your system excels - it'd be good to get the tree we're publishing
verified that way.

--41bjdpi19TcwJlr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTZ+JAAoJELSic+t+oim9MBEQAIDWxCdz7INpJiVQaES0DN6O
9nv166iFVBcWBdFUSexOcJhQPt7krapRo3JGDMXIdKBUxEhmSP/mY5XSXvrFp8P4
eo69W0pXGmg7rxn8gRGQ5DyCaiF/h/RGyBCuzk4RiEHmA8F6PRvalgmy4HjyDrTI
H+0rz4Vy29rxhxD1alMZ+zfvr4zs4T8eomXKDtyGIfD7F99vMwae+4y+6Ec9bP+0
ITyGXBYlulX6DND5N6jiajlAGL2qf2Gw273cBokOOoG2nhxc51W9LtErxSVBMEUa
0gJjj72dcmslHV7tyZws6LF2lcYvJ19fZuqS+9YWb+WdjbW2z1QVb1xgf8+jPxfT
0EienvXx0ePKej86JnJcS1OI/Eh6R8suQRm5L16tPT69eoeQlED7oq8Bl7Uj0RGe
h3pz9SooB9PWohGdy8jya4I0ZFPmD+eV55hTuMlsK8JZcTncGE14Oy6W+h1QkwS5
GWK2NlTJAGfO6g2ExOVy8oRKdy5W2Qs1K2U9UvzfSh2aKFAxQBWdvYU4x9xVOAkc
pL3weLEWmTllHzhLTyNTQXDDCa/lQkUwcrAOtjhC3nD8qPL7MygMu4MqU1eUbl5b
w17ypgMQ2cGBkU73whor6+XZU7WNLQNIM2N2hXCV6SGITKWK+9BeEBSDffsT/aGE
817gUX0ptYjO6V+a7w2O
=E2AK
-----END PGP SIGNATURE-----

--41bjdpi19TcwJlr2--
