Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3GZOLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:11:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33109 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3GZOK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:10:59 -0400
Date: Fri, 26 Jul 2013 15:10:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130726141016.GF9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VXtJLXyETdkgZBRU"
Content-Disposition: inline
In-Reply-To: <20130726130927.GC4219@netboy>
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


--VXtJLXyETdkgZBRU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 03:09:29PM +0200, Richard Cochran wrote:

> Unless I totally misunderstood, the thread is talking about letting
> established bindings change with each new kernel version.  I am
> opposed to that.

No, nobody is really saying that is a particularly good idea.  There is
some debate about how we work out what an established binding is but
there's no serious suggestion that we don't want stable bindings.

--VXtJLXyETdkgZBRU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8oNFAAoJELSic+t+oim92HMP/jhyJiSZP5hs+avasx0+6kVf
Ol/m2xS8+s3vU2EO5ZFwTniG5qvSAfrGqF+wPPh6/16hQqhZS28oA1ezvySGOSM0
+YJ/yXQRtt9abnZqsDw/5gu3TYuV1oZPLclKlugSxErGAJD1r+7Nh2VcPn1dudXl
ksYWofOeB6lJv7yUV9LtXQMvRFeEhroMt9+2bzDAd2JE8Eb8ixe0cEElRem4IyOz
+XpOWY4WJtrhypmPL+SMGf90DKJ4YJHSG+QxKLSrOpqAFG0XKSBAkvNgnBb+8iHR
8Gw2FTvUB+2noLodtgs4AuBdHlj3JKsZQFfK+//vHrL0L/mZHAEOGfDQDug0Fn9H
kjP+Ti0I+oqYpRAi0UmrBbKI2wGxtoZ/774x1SBUxBKXxSpyRlMKGAs0fMGG8nR9
CTsCct0ZJRb70emfmEdK05pJj+AjaCGjYBXDmnzwUrba9roFp1eEczchq6lrqF/r
9VLkKwwIYCZ+sbp4wX668aJvG4k8SgErWkV+aWDfktPNzLfl+lAauram1sO58Noj
YR4n/WpgV3PaoIsOY5cK9xhbM/K0nnVYuKn0GknGhVw1RqZ75Eo23TUR//kgekgO
sHezEoKamVq1RrKj4dXZOy9YbC7iGE+/CrkKZwt84p47z2nq0j7bs56DXKo3ovBq
tjAJAzE9nz0/wwyMHpOt
=TZZy
-----END PGP SIGNATURE-----

--VXtJLXyETdkgZBRU--
