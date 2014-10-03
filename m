Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbaJCXO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:14:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32952 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaJCXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:14:22 -0400
Date: Sat, 4 Oct 2014 00:13:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Message-ID: <20141003231334.GA4609@sirena.org.uk>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
 <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
 <20141003122736.GH26643@leverpostej>
 <542EDCDB.6040406@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <542EDCDB.6040406@roeck-us.net>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2014 at 10:28:59AM -0700, Guenter Roeck wrote:
> On 10/03/2014 05:27 AM, Mark Rutland wrote:

> >>+Optional properties:
> >>+ Name of the optional regulator subnode must be "regulators".
> >>+  - #address-cells must be 1.

> >What's the single address cell used for?

> I think this is required by the regulator bindings.
> Other regulators use the same, though they don't typically
> mention it in the properties list but only in the examples.

Nope, nothing to do with regulator that I'm aware of and I've not seen
any examples (but I don't tend to review users too often).

> >Mark, what's the preferred scheme for identifying regulators in a
> >container node?

> >>+  - regulator-name: arbitrary name for regulator

> >Drop the 'aribtarary'. Either this should be the name of the regulator
> >on the board, or it shouldn't be necessary.

> Not sure if it even needs to be documented here. It is already documented
> in Documentation/devicetree/bindings/regulator/regulator.txt.

Document by reference then?  It really should be the name of the supply
provided by the regulator, that wording is probably good.  Given that
it's a standard regulator property I'd not document it here at all, just
refer to the generic bindings and say any suitable properties there can
be used.

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULy2dAAoJECTWi3JdVIfQJgUH/iGxSy0sCJT8+tCSidfBjYQA
zNd9zjqXv89bDKeuWLOCR8TXi3Qx5bLigrgEH/NaC0RBrt+XcfvVOnr2oiXiMwbn
bDHQV++qynsvScxjJ99FO9GYTyVdnzwDs8ek1XRDDbH39W407uIEHgBkCXzdxj1l
oyD1tXjkMb+VBOMDi1LKBML2MI4kXcBWybk/yUQkeQTDtCmOi0oEq5slLJKrTvI9
OsM0/pJ8GnzuxrHpmKisghKsKuALEZKDQq0jBR+5OREelhmZgyg/6wLkiVyw4mt5
Jas4gNN9z6fMn0E+x1Fl89XgzPcL8ETuKp2gDuvaagBcazUzDb80q+O6/lCJCLA=
=aDrK
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
