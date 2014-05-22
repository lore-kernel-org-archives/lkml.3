Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaEVTVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:21:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39392 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:21:13 -0400
Date: Thu, 22 May 2014 20:20:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-ID: <20140522192057.GU12304@sirena.org.uk>
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
 <1400604211-9447-4-git-send-email-t.figa@samsung.com>
 <537D8788.8030904@linaro.org>
 <537DD2C0.4060802@samsung.com>
 <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
 <537DE714.1090407@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IkIwblIRKmNDLbQ5"
Content-Disposition: inline
In-Reply-To: <537DE714.1090407@samsung.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IkIwblIRKmNDLbQ5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 02:01:24PM +0200, Tomasz Figa wrote:
> On 22.05.2014 13:44, Tushar Behera wrote:

> > I would be happy to get it done that way. I can see a patch from
> > Sylwester regarding this, but there hasn't been a conclusion as of
> > yet.

> > https://lkml.org/lkml/2014/4/9/173

> Have you mentioned your use case there? It might indicate that this is
> indeed an important problem and that too much bikeshedding doesn't
> really make us closer to the solution.

I've certainly discussed the requirement for this feature with Mike in
person a few times, I don't know if anyone else has been doing anything.

--IkIwblIRKmNDLbQ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfk4WAAoJELSic+t+oim9NLwP/3pNGAI55UZt9124yUSsfLtp
IuB8idoanzPbOfFLgBG/d3oMMSF4RVadU/EqzrvZAEXaAfWMUn7xljwWL4KiAKsd
UGLmM3VDnbcraPF7b6kEw6ak1VD1Or44oYr8IpYyEyr/71i+Eu6qAQEAIxWJLsiT
vP+b7xa+ifAS4ndFh4bNK65VmiLUN4ugS6Vy+qkZrtfCSJjbwBuPDugX+TTxqrYP
pQHOqQqtRvTUcdjbL44x8v+vecVjagSc2rsqiscVoyS78Gn30vO5/uFitEYa/P3M
qKy6UK2A+FNSke115/0xardqrMZRFwQ4+AaQoZsiiQ3R5bafokeSWqzmmeBR43fJ
cHzbQKc4c2ood+iSObLHgaCXT3osMI17PUQWJmcR4g6h/LOKSah5Y7iYJ6gKUw4k
YZM7jJLKyPUCsYt1OHp3IqCEs35t2hgV0UfiC7+tMn2Y0I0syrpZaxsbjqoSgiwG
85s34AL+9PEzUJzZrdVT2qXDI7DnrVLbJ3yscpGIDxJbRkBPfmVyid+PtGQjFznS
YToau/o10Yr+h5Pq6MriZ30hbpkcURkQ55jfuD9oCTnjP7YJT4mROYNfdL9sDsrQ
byykg0qtXgC42V/x0ABBTyFTXGgcmW1i5ac6qYTlkuRe+KswotlVUEU07VT/WhJr
Q7JRJow76Rzrw1la28gh
=VPpM
-----END PGP SIGNATURE-----

--IkIwblIRKmNDLbQ5--
