Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3GBKb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:31:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50837 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3GBKbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:31:25 -0400
Date: Tue, 2 Jul 2013 11:31:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: David Dajun Chen <david.chen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Message-ID: <20130702103101.GH27646@sirena.org.uk>
References: <20130701164833.GL27646@sirena.org.uk>
 <1372757513.28415.2.camel@matrix>
 <20130702093130.GX27646@sirena.org.uk>
 <1372759357.29900.3.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g8QXd9oEDP0MouNi"
Content-Disposition: inline
In-Reply-To: <1372759357.29900.3.camel@matrix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Multiple DA9055 chips
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g8QXd9oEDP0MouNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 03:32:37PM +0530, Ashish Chavan wrote:

> > OK, in that case the CODEC driver is just plain broken then.  Did anyone
> > actually test this stuff?  Please fix.

> Yes, I think so. Actually the CODEC driver was merged before PMIC ino
> main line and was tested at that time. I will check with PMIC team if
> they did test with CODEC.

> I guess the fix should be in PMIC, right?

Both drivers need to be changed.

--g8QXd9oEDP0MouNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0qviAAoJELSic+t+oim97eoP+gOx5ZqxRkblT8lV/P35yvk9
XTp8QGrGoJKloI/UrGr61b2y/l65kCm1lHLpCMy4AdR8fj5a8JSwRBgu5pMKNQ+h
YO8mos0PcLY5EZxXs6aAUn/FsTxPnNCcxsegCltadlt8bGZ46XApTOdUH+Ng3HOH
d4JETfVv/Y1Bp0/c/W8InrO6t2eWARq3KQwq5jwIgpvZL2MqR4Jy1MR6WGcd5v1p
uFOIRIhEjSQXXFcjf9PwJpw7ywc8psHn4UsA918oEcOiP1LF0XWIO2HczxO7A2AQ
MWliv7mGFiEb9vycus6gTsb7mRTyuwJ5DqeWsSZ5BHLxxUbiO2sacfLOEYsynhYs
xOe78V/3ea0+kc23CxuXc3nvi41VHmOp5uMrh5uCiOZxfasXOljg898tHcN7tvEG
1nhqrlFSiCiV6Tz69DH1sklfyyaetDUYkEtZ1/otUnPXZGkBoODFIbRCldLqRLy8
Mj/GH/SmkPDCRy+ngjmWX4d303lIh91eqJbTUP2hcDBrmN/8e4zXvcOUJ2cvBq2s
Zv2qj/ph6N9fg24r63tEPkot7KPoNr8sVZB5kYoQ7nGCe6iygjRzLMkHaO3rp6Qf
cLMCHeM/nEZyrELwsTKfng5eFUEG/nyS3j1YPa8cq+oU+ANfCQjjF0maaNRQ5G8T
6TzGPcHLwjSGwiIlEbrX
=hY9q
-----END PGP SIGNATURE-----

--g8QXd9oEDP0MouNi--
