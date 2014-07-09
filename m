Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaGIJRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:17:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54611 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaGIJRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:17:21 -0400
Date: Wed, 9 Jul 2014 11:14:42 +0200
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, mark.rutland@arm.com, galak@codeaurora.org,
        robh+dt@kernel.org, linux@arm.linux.org.uk, balbi@ti.com,
        tony@atomide.com, kishon@ti.com
Message-ID: <20140709091442.GN30458@sirena.org.uk>
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
 <1404884193-20580-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/pvEKOcHgREgBce"
Content-Disposition: inline
In-Reply-To: <1404884193-20580-2-git-send-email-j-keerthy@ti.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/7] regulator: tps65218: Add fixed_uV fields for
 dcdc5 and dcdc6
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/pvEKOcHgREgBce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 09, 2014 at 11:06:27AM +0530, Keerthy wrote:
> Add fixed_uV fields for dcdc5 and dcdc6.

This doesn't apply against current code, can you please check and
resend?  There were some cleanups from Felipe that just went in, it
looks like a collision with them.

--J/pvEKOcHgREgBce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvQf+AAoJELSic+t+oim9rFYP/1U9OPrzNpZaVlB8ZxLMBw0P
UsxVMF8sAOpr68FxKQn8cp6dvovCkRraTg7KNoRaPKkbZpIp+XRoC366wvZwipYd
73QTVfpSTrjhc49UCc0H7B+780z0s5g1oAWgGZuMPyWs9RGM1mHBrUCRw1jP1yjH
WX9wylkzcwDuAhFvskFyuWiZPcuxBW7ENLKSkb+X52lrmgBcZUct922ac5tJipvT
T9l6CcabumZv1P+VLQM1MjL1xfoLXEOXYAfyG+N1XUUkmFhVahFbbN44KxCUif/T
03bOdhb28pS0UeB1/4VD0khe5P/XECgK79AIRWjrU/8I7rSdbDeh2vY8FQDR8UeR
4r9gDH4tOh3yOfxF8UfVbSXCxYHjGq7EmA7aD6uSXqoIrr3y9C7d4N5H4f1YtvNk
CO3pgYz/lIcXk831+IVN/RpB1GcVo1Z+hTvXTuBM21LPb3V9sEHwvUkqzZ0MZANP
Y+ksia8kM+NTYTx3p+1MAjZKOo/J7i1DTRIaqstotCkBrcT0FAqHXTgkM8GkYev+
bLlghl0fEgsrAm2PrZVQ0Qjw+xxkC6KDcuqn03DYvK/M2avyXd4GHrWPyB+Vo/ec
D74bvJYfgNNbdmOW1AhdAf/iRT9v0rpS/gG1010peDVbBLpG7hnrbQwpM5AnmRDw
HCtbJVBgnuGSkue7dtYu
=lflV
-----END PGP SIGNATURE-----

--J/pvEKOcHgREgBce--
