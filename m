Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3G1L2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 07:28:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34556 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3G1L2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 07:28:13 -0400
Date: Sun, 28 Jul 2013 12:27:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130728112746.GM9858@sirena.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
 <20130727084825.GA4707@netboy>
 <20130727104018.GC9858@sirena.org.uk>
 <20130727173748.GA4813@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PI2T0JrbAUafY2qi"
Content-Disposition: inline
In-Reply-To: <20130727173748.GA4813@netboy>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PI2T0JrbAUafY2qi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 27, 2013 at 07:37:48PM +0200, Richard Cochran wrote:
> On Sat, Jul 27, 2013 at 11:40:18AM +0100, Mark Brown wrote:

> > We did have exactly the same discussion when the DT transition was
> > started - this isn't something that people only just realised might be
> > an issue.  There was a deliberate decision to focus on getting the
> > technology deployed to the point where it could be used as a straight
> > replacement for board files and accept that sometimes the results won't
> > be perfect and that we may need to rework as a result.

> Can you tell a bit more about this decision? When was it made? Who
> made it? How was it made public?

I honestly can't remember exactly - it was part of the discussion about
keeping the .dtb files in the kernel IIRC.  Given the timing and the
fact that I remember it it'd have been a mailing list discussion but I
couldn't point you at it without searching for a needle in a haystack,
sorry.  Perhaps there's a LWN writeup or something.

It's not the "we don't care" that you're seeing, it's more a product of
"we're not sure what we're doing yet, let's give ourselves a pass if we
mess things up while we're still learning" so it's probably buried in
some thread.

--PI2T0JrbAUafY2qi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9QAvAAoJELSic+t+oim94hwP/jMU8xE6tke4MrdRyKEsbnje
QokN+rpuJ1K1f62HstHucFjmQlTgDd5Wb0MtSKX122Us5++9RRJbtqB2wSxQ72E2
WDFzviIWyFdO6TxXXNzzgJTxROFt8FUDk82RfqTpwP/uYGddcEnfCJXkRqS0VJpJ
lWGavSswnGCoK7YqSasSXllrq2WEWZHnQLcwiNjUt9YoAgrimLpTeMbjr4UXys1E
uzCG2lBbQh66eB74d+JxHNbkRenibdvLHviGy7xbi3uY7K9MXJI+Ar67VxwGXfRX
dGP51h8nHcReZXc4NWlzlB2vwO4FOGfs6A+1VeODHDaoqg/NndLSHNl+44QGCRvK
7mmkgngKFUXQGFbHTtkCRRFPLgSslleBgcmYod5gJ5nbBrkBwX6obGSQhK0XQ/QI
NzU98ICbAD6PKSiRyPJuor2b0+0tUEckhslZCdKELxCC7nmAhAWFYVrWsKS/YfBA
6HzVNB0PjtfRH81BEv9/tzaKRPOzo/5IVZsd7AH/esDzYraMuQPh4/utJCA+A1Li
LIurv/hqPpOnY6UgJuMckM7isSdJlakFdTJIvIQ4iWFIqmq4p5okLMLbTH1rXE7h
Nwsa1lWrd4Br5znuzqZjFKprpm2W5Yf5VLhcIudI04nZnwCiQtrodEUkK9f/Bu3F
jGrVvQH67P52AEIFYa9x
=L0zL
-----END PGP SIGNATURE-----

--PI2T0JrbAUafY2qi--
