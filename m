Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaFWLSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:18:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54338 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaFWLSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:18:30 -0400
Date: Mon, 23 Jun 2014 12:17:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, sudeep.holla@arm.com,
        linux@arm.linux.org.uk
Message-ID: <20140623111756.GY24291@sirena.org.uk>
References: <20140604232546.704156131@linuxfoundation.org>
 <20140604232547.006861681@linuxfoundation.org>
 <20140605160500.GD31564@leverpostej>
 <20140605180524.GC4121@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w+MAdceOglSEzbpc"
Content-Disposition: inline
In-Reply-To: <20140605180524.GC4121@kroah.com>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3.10 005/103] irqchip: Gic: Support forced affinity
 setting
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w+MAdceOglSEzbpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 11:05:24AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jun 05, 2014 at 05:05:00PM +0100, Mark Rutland wrote:

> > This patch alone has the possiblity of breaking CPU hotplug on arm and
> > arm64 (specifically it breaks hot unplugging CPU0 where interrupts may
> > be left targetting the offline CPU).

...

> > Unfortunately there is not an equivalent fix for arm - Russell objected
> > to the approach [2,3,4], and that's not yet settled.

> Ok, be sure to cc: stable on the patch when it goes into the tree and
> I'll pick it up then.

Sadly that fix still hasn't materialised so stable remains broken for
ARM.  The discussion was restarted on Friday but Russell is looking to
Thomas for input.

--w+MAdceOglSEzbpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqAzgAAoJELSic+t+oim9OcgP/R6hPRsJdMbSJv0S503rq6lS
fY3f7nCPlBaaY0DW34PNYArsZc7NiBWf8wqu8z8xO1ZhSHGncBlY/ECL9PvoRq5M
NuTQ8jtTrCor1wVXw4eapW3c4/ZDuiGHfeiEQMu7AM82/dCRITA5geDvFRE819x4
pYzBkEg0sYMO0/56jQDiwmr1EJ4Z3QcszuazVHu4+5FArUu59Qgt+fJsKH6OFMoO
Hgy/ZWNsNpVZtnviwkFPu6oyvQqLXCOlWeuRS7UjHlR1Xj3mGXRCqV0Q4lhNB9CO
/WlG5cm4v492ib+7xUBsOwlhNTat7L4rtM8YXYhP00jBxslGEyshAt7bxaDUlUjT
VKHwl5QVJdjHqrzh7aublxW2cphNQrsuV0zPly7Xu8JPqT9CG9pY434m5hhNa6Xk
/udH/NORhQKZDqe5LciYgXc0qj88+DQojwc0ym3bqYmYlhsiMUsOd/f2f9HaJeSJ
LEYlJIKPaxQvNpUbFwRnYXyns3OitLkcGtLl8fgQ/fH2Rn2kAdEgGlPGwLzGPFf0
CY7KB/bvFyrRSTxMugVoyI8JyiWI9nMxf2Ml4VwgpsUpa3nQ+OAQdVqCWqjZDVN0
lbXW8hSyIf886wBnLuwzdIRZtHKJ5xJq0dyKNu3pQeINeclBTRPzvdc/aVsDaDSV
pNPc9CqluJbrT1V4WjVq
=2G3y
-----END PGP SIGNATURE-----

--w+MAdceOglSEzbpc--
