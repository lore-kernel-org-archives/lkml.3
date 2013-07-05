Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3GEOIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:08:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52379 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3GEOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:08:34 -0400
Date: Fri, 5 Jul 2013 15:08:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras@ti.com>
Message-ID: <20130705140828.GA27646@sirena.org.uk>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
 <1371849949-12649-2-git-send-email-nm@ti.com>
 <20130704154105.GD27646@sirena.org.uk>
 <20130705135507.GA17439@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47uHu9eEG8RBDiQe"
Content-Disposition: inline
In-Reply-To: <20130705135507.GA17439@kahuna>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to
 control PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--47uHu9eEG8RBDiQe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2013 at 08:55:07AM -0500, Nishanth Menon wrote:

Please write in paragraphs, an enormous wall of unbroken text isn't
helpful for legibility.

> On 16:41-20130704, Mark Brown wrote:

> > So, this still has the thing where all the data about the PMIC is
> > replicated (but now in this driver).  It should be possible to pull all
> > the above information except possibly the I2C timeout and perhaps the
> > I2C address (if there's a separate control interface) from the standard
> > regulator core data structures for the PMIC.  This would allow the
> > driver to Just Work with any PMIC without needing to add it in two
> > places.

> option 1) we just bypass get_voltage/set_voltage to point through to
> this function. result will be something similar to what we got here[1]

I don't really know what you mean when you say "bypass get_voltage/set_voltage
so it's kind of hard to comment...  the link you posted appears to be a
link to the code I'm reviewing so it's not terribly enlightening.

> Again, based on this discussion, it is wrong - and we already did implement
> the *wrong* way in OMAP and the new code is supposed to throw away the
> old code once all relevant platforms are converted to DT.
> - now, we could improve this by passing rdev and slurp out required
>  data from regulator structures, but obviously, as you pointed out, it wont
>  be sufficient.
> - In this solution, we will have existing regulator drivers supporting
> additional data path. *but* that also means that existing regulator
> drivers will need to be modified to handle multiple data path and "Just
> Work" wont happen - so not really good other than screw up existing
> regulator drivers with handling OMAP specific APIs in them.

What makes you think that the existing regulator drivers need to be
modified?  They already have all the data exported to the core (or
should do)...  the only thing that's missing is the timeouts and it's
not at all obvious why those need to be tuned per device.

> option 2) make omap_pmic regulator use twl_regulator - regulator
> chaining.

Again I don't know what this is.

--47uHu9eEG8RBDiQe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1tNYAAoJELSic+t+oim9yhQP/079dA+d6EDSqViNUz8r5j7M
/RC/RLLjEXjJQ2cEqDjaOSjqaUPW98ynqakL7Pl7CNOB4fQjyIO2ClAiZ1TshMCu
xJoSRAXDdalbH+Z7XsQC3qBVkzP9doEHf2vCm5JiMUlphSdm6fAtLigvz/PDd172
fwEjb+oFoWWhy8Gd6TbesfuL8JglTxuEwZb7voMTFPbs3E3vrHqPr4pSAngHuHRt
EUFCACUTvJ3EkW4HUBC9N29VMOi/I6iTBPbQBrqHCoF/KfysptLkG6eXqUv+/dMR
tJXr9mH6eHbF24xXDnzztq/S4pIXb+nxsv41bUPdlBPgRPOi2ggwHihuBMWrXpIg
tEmbqv66lHJWonSqJUI2lhLmiQKhJ909AaNyVHyTF5I32ZPW7J+0WQ/yd/rziMlX
uUBZa60UUmjtMncyciSnEaje1LPzp+NyJS6Dij7AG0qYBIeSIjYCeU2xSuNeUTdj
FmcWGJQohLyamJXowTmxxtcZ8uiTwXK7Y5rXIfH3PBSL1rN5HU4sp9hvMW8LWs0N
tQW724OfnkRt70EdR6DrSiGq4HFKkqaAjatFzRf0QW+7vwxfLwp7YCqwEiaVoyLZ
R95i9C9zHMnT3oerwiEMx1jhaMYzyGLJjL4fTak26UzRTpeoxBVXKpVlpryK7ubN
UogTwCVs7QAG7rWNNWx7
=lyOC
-----END PGP SIGNATURE-----

--47uHu9eEG8RBDiQe--
