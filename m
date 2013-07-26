Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab3GZOk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:40:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33428 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab3GZOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:40:55 -0400
Date: Fri, 26 Jul 2013 15:40:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130726144047.GH9858@sirena.org.uk>
References: <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
 <20130726132709.GH29916@titan.lakedaemon.net>
 <1374846070.14574.92.camel@i7.infradead.org>
 <CAKON4OzrkHzUzKkULWCgiEpAtJ5gLxUm78R5ctd7p6trqq_gCA@mail.gmail.com>
 <20130726142140.GR24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="koElQQqmLVmRs57w"
Content-Disposition: inline
In-Reply-To: <20130726142140.GR24642@n2100.arm.linux.org.uk>
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


--koElQQqmLVmRs57w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 03:21:40PM +0100, Russell King - ARM Linux wrote:

> So this is why I'm seeing patches just a short time ago removing existing
> compatible strings from the DT descriptions and associated driver, and
> replacing them with new ones... meaning that the old DT files won't work
> with newer kernels.

The big question is if you're seeing such patches merged.  People making
mistakes on submissions is totally normal.

If it's the case I think you mean TBH I'm not sure anyone cares, I don't
think anyone is using that stuff in production yet as those chips go
almost exclusively into Android phones.

--koElQQqmLVmRs57w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8opsAAoJELSic+t+oim9Rh0P/04SxSGMkLPCB2lZ532/7yTR
DuD1QKn09hybTdjqHGkUMr/zKKFUtUgwtX5HK7KMnyd7KKdnHPyoCDimx2sperDJ
4+Ci9CZvewIMKMv9nLvxyC6Zh8uxwFBq52zlJMYGe4oauXk3nQVwYfY4tPSPh6Kf
+LGnIUQ7x9bLk8t8WC4b0NUZI/IVud1LSGqFDL774HuuaHFwdBnWrZQTo5W99hyn
kTUx6jnHpD6KyyW4k4Hbmwht8zRNDzkt2AbvKW3mRN6HKWiA0u9ljKCk5rMLXV+x
EA/IsCBCwfymySulY++Yu87h2aXKHNzLQA/Azt4dtBrSabEQesv41vaoVWDGstYB
NtjUS1UYzl6Q0kxlwZGGs0HYJ6M8OLr4iTdnAMTfrul2UQzfQiQAWthhL9hltQDD
SWooca3jQduAnctOfAQ/e1MTc1hMgiSwuwE9Z77C8u+sZEGTDdhYaP2Xs1jl+uvm
B+AIXVAdNxVvlbdTsJ6Q24DRwJWetrtJ1Yjs10J92KPPsEp0AJ224u0hg7YJZ5PI
DVfJ52Qg0RmdaqvlCnMfF9W0h6B/3ChXY0EafSZgCcM0Tx7QUeOaG4vvHiPJFYiI
MV6rrPDAMLW765Lp+b9p+SdOPEfXGcGfP39uhwsv2ftnrBXkl8qOv9P/5tYry/f/
ALI3VUvNpAGli9InTRfX
=kOfF
-----END PGP SIGNATURE-----

--koElQQqmLVmRs57w--
