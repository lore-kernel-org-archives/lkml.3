Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaFVKrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:47:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53358 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaFVKrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:47:22 -0400
Date: Sun, 22 Jun 2014 11:47:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Message-ID: <20140622104708.GK24291@sirena.org.uk>
References: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
 <1402601652-24641-2-git-send-email-agross@codeaurora.org>
 <20140621101303.GE5099@sirena.org.uk>
 <20140621185646.GA2601@qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDymnuGqqhW10CwH"
Content-Disposition: inline
In-Reply-To: <20140621185646.GA2601@qualcomm.com>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Patch v2 1/3] spi: qup: Remove chip select function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDymnuGqqhW10CwH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 21, 2014 at 01:56:46PM -0500, Andy Gross wrote:
> On Sat, Jun 21, 2014 at 11:13:03AM +0100, Mark Brown wrote:
> > On Thu, Jun 12, 2014 at 02:34:10PM -0500, Andy Gross wrote:

> > > This patch removes the chip select function.  Chip select should instead be
> > > supported using GPIOs, defining the DT entry "cs-gpios", and letting the SPI
> > > core assert/deassert the chip select as it sees fit.

> > Why?

> The chip select control inside the controller is buggy.  It is supposed to
> automatically assert the chip select based on the activity in the controller,
> but it is buggy and doesn't work at all.  So instead we elect to use GPIOs.

OK, though it was in manual mode.

--qDymnuGqqhW10CwH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTprQpAAoJELSic+t+oim937IP/RApkLGTVuPPN1kQlVhJt8Bu
11N0da/sCNYBdiHXgH/HMMXsEZSrXQGDfjjlSMm2XirJxDHJ3s68qkgE82ooP9hD
regLghKR5S6qVtLGlfl/30sTXION6xhaVsnqRmGsad4knNH9o85snu00GWtcjOEN
OBK6V+/Ei+W8ngcxD3huj/Dsy/dEZsFl1wmlAZ5FiXEe9JDYBcGjJLYr2UcwHm4C
OIf0c0KAmYVGUegawErAUaYOw+7vlIXjyfy+z0Rw+22FTDLpeBckVMhCKrQcOE/r
fcIY9R9pW1SSpoeaYpp/X9S7Eg5ZQwMDm+QMoZMFLCqQhEKjjQaLVKAvK3TZOSUs
aMrk4x1OXMF/gsXGJDsIhdOxLxlCiz5/yhVL+Z4tjp1/tj67tqzJJTB4MxcO341/
DMRIvDNDjC9mM+Ulr0I9fmKWndyqWKYhG0sE5X5fMiQ+0Zwy7aCPsCTy/5oZI2NQ
jl70VSTpbnxMSZhKsrD8WHUneDjDPcnQ7YMj8Mqex1DxfrUgW3kwGBM/qG9fL2v9
Wn0cPost2iUBIIRFhDcVu44gnjkmq0NAqPiWA5NpYC9y/NeYjmYtdceLtc4e9PcK
6GBm+h6SMsAU6M2gkbILhjcxtT34saLThai01qOh6lIMhh1pYDDqvyJ0rdREFele
oaBSeZZ0Prfs8jHowqht
=5fWX
-----END PGP SIGNATURE-----

--qDymnuGqqhW10CwH--
