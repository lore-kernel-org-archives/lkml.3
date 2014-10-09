Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaJIPzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:55:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42677 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaJIPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:54:58 -0400
Date: Thu, 9 Oct 2014 16:54:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Message-ID: <20141009155440.GV4609@sirena.org.uk>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
 <20141008234541.GQ4609@sirena.org.uk>
 <20141009000555.GA27476@roeck-us.net>
 <20141009001213.GS4609@sirena.org.uk>
 <20141009002531.GA27920@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK5WMeVMNp/FmgOI"
Content-Disposition: inline
In-Reply-To: <20141009002531.GA27920@roeck-us.net>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hK5WMeVMNp/FmgOI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 05:25:31PM -0700, Guenter Roeck wrote:
> On Thu, Oct 09, 2014 at 01:12:13AM +0100, Mark Brown wrote:

> > We'll do something, just a question of what and what the default is.

> Ok. Note that a boot parameter would not work well for our use case,
> so it would be great if we can find something else.

Could you explain why please?

> > Shove a dev_name() on the front if we get a collision?  I have to say
> > I've never cared, the debugfs isn't that important so it doesn't matter
> > too much if it fails.

> Sure, but, again, I am getting lots and lots of those error messages.
> I probably would not care either (and probably not even have noticed)
> if not for those messages.

> Want me to submit a patch with the dev_name solution ?

Yes, please.

--hK5WMeVMNp/FmgOI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNq+/AAoJECTWi3JdVIfQKJUH/0QaJHCpq1t4e+UPRJEiA/91
Yu/42hjSFBGEFAiT7dED1vvqGfi3nlP9y+i6vGx06RoTDO689jjMuQz/sW2HYsTI
Z0dqCTX928VBFOq9JxWCznnPksK6KZ+qzDyAbh3B06yYsBFDM+jxZZGHoV6k+cwA
U80h9Ql6nvLIbE1Sajht2jGdGtzBW6ck9mr67UEloOSOl/GWh8qS/6Ly/RMO/Uqj
y5ZoYPJAVWZd+qeXsKpznEmrF/D0F9M1CZL+LfrBqLEerUEXqcyGotHia++nDsPS
ffsJH5EJdAlY/c+SzD+Sxu9OChDhVJuRAA0dUxHGOS/5w+vwtZFDRUFMFWhvJoE=
=5vYd
-----END PGP SIGNATURE-----

--hK5WMeVMNp/FmgOI--
