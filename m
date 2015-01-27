Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbbA0SbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:31:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36590 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbA0SbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:31:10 -0500
Date: Tue, 27 Jan 2015 18:31:02 +0000
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20150127183102.GF21293@sirena.org.uk>
References: <201501190238.t0J2cH7R013166@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mccM4FjNDckYFlPg"
Content-Disposition: inline
In-Reply-To: <201501190238.t0J2cH7R013166@krsrvapps-01.diasemi.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: da9211: Add gpio control for
 enable/disable of buck
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mccM4FjNDckYFlPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 19, 2015 at 11:27:05AM +0900, James Ban wrote:

>  Optional properties:
> +- buck-enable-platform-gpios: platform gpio for control of BUCKA/BUCKB.
>  - Any optional property defined in regulator.txt

How about just "enable-gpios" - the name is pretty long and it's in the
node for the buck already.  Otherwise this looks fine.

--mccM4FjNDckYFlPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx9llAAoJECTWi3JdVIfQxiYH/2bn5dTn5lyEPu9Dykl9RjrL
CSCvyb8Wmf/0gXtMK0PgaIworetwVjPY+tknFC666iJca8Xi009POFV8qilBZH0d
JXPhhUTr77okF16pZ4vDhdqlPP72VucdGwFs5tPG4lqjEqkbG+h0Gq9072drlb3Q
60QXT0HFLPcX5l8iRGCWf0QB5g2qqwg740469UqoATj2cUz50YkpUrJoiL10fOJN
sWSV2Es7lJdGXsbd1lGr1vJD06I6WnPJna+JYVVq+C3+s4SpM5kkh3CKHDh4/Cky
UZ/nHl2wN3JGUjJorvMfaOGD9yd6tO7CSj3NNLeV3xdN5k139ogMXsBK+rGFdsM=
=hm24
-----END PGP SIGNATURE-----

--mccM4FjNDckYFlPg--
