Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3IIPws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:52:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42012 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab3IIPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:45 -0400
Date: Mon, 9 Sep 2013 16:52:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Message-ID: <20130909155224.GQ29403@sirena.org.uk>
References: <cover.1377202730.git.joshc@codeaurora.org>
 <46db5901fe4d04d09cee8fd81ea1c62068ee9503.1377202730.git.joshc@codeaurora.org>
 <20130822231054.GA31973@kroah.com>
 <20130823160625.GP4035@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6UK98fIWRAfByB6"
Content-Disposition: inline
In-Reply-To: <20130823160625.GP4035@joshc.qualcomm.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC v2 2/5] spmi: Linux driver framework for SPMI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6UK98fIWRAfByB6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 23, 2013 at 11:06:25AM -0500, Josh Cartwright wrote:
> On Thu, Aug 22, 2013 at 04:10:54PM -0700, Greg Kroah-Hartman wrote:
> > On Fri, Aug 09, 2013 at 01:37:09PM -0700, Josh Cartwright wrote:

> > > +	"Example: Read 4 bytes starting at register address 0x1234 for SID 2\n"
> > > +	"\n"
> > > +	"echo 0x21234 > address\n"
> > > +	"echo 4 > count\n"
> > > +	"cat data\n"
> > > +	"\n"
> > > +	"Example: Write 3 bytes starting at register address 0x1008 for SID 1\n"
> > > +	"\n"
> > > +	"echo 0x11008 > address\n"
> > > +	"echo 0x01 0x02 0x03 > data\n"
> > > +	"\n"
> > > +	"Note that the count file is not used for writes.  Since 3 bytes are\n"
> > > +	"written to the 'data' file, then 3 bytes will be written across the\n"
> > > +	"SPMI bus.\n\n";

> > The help file within the kernel is a nice touch :)

> > Or is this only for "debugging"?  If so, please document it as such.

> It's there because it provides a useful interface for debugging of the
> controller code, and for simple peek/poke of the slave registers without
> having a full driver in place.  Will document this.

This looks awfully like a version of the debugfs interfaces that regmap
provides, and indeed the entire bus sounds like something that could
idiomatically be supported via regmap.  Have you considered doing that?
This would give access to standard tracepoints as well, plus the cache
infrastructure.

--d6UK98fIWRAfByB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLe61AAoJELSic+t+oim94DwQAItDtnVxRCrURJGTpyF2B53+
req1tbVvhFIwcaQ+obM55azChrTrkvEvgixfcRBi3THoX7u15+OyiDXKAV1g1zQ7
p2EGvHe1OzLjVmsp2G/HYD0Dc1tDVlvhixRhaPSEsK92VVWFGXKhg0VrmLFJ73JJ
jFjTyqS6vopVZQMk7v/850g3Hf9ujSXQdYPRvgrwsMV+sq2DdHxZkDD/HrxO3vCG
eqUPgIw7ysBJSavzGX5r2xNONqhWT/GknTfv2ra0AJUJf01N0otXYVyIJxMoE9iI
1wkqoMIspRMsLhdRSoX5pvcfTACSvuqiR9hkVKM7h61+FHGPaxnsN6KPuuJtG5uM
Qm33GEL7FhOGEyHr3yqnMvRVmAbrkFyAUQq6lLpW6dwBV9/9sIktMI/MtlLmcMZB
rrXjLTYJhCqbL/PX66jo4FoAWNekrSVmUVe0aUpRrFR2i9qiGCEU0G1ULpKmAxJ0
wwJcIpTVppVh0e+HJA/FJAAq0IH7Z/Up8/Wwo8UEDCPelLReynSWZimBt4+q5O2U
PrQzZ6OvBg5UxVUrp2aD2dH8bzcFdKTOVzlkv3vYJNL/MnIPzyok5xRyvdynMimr
amKgZDQGnkqR5Q39Z3W1etamSFotwzQuX2bm4AhWZLWiM2MjEVZPJGWUw37ESnv0
WugDTYETxIFIoAoc1X/E
=W6fA
-----END PGP SIGNATURE-----

--d6UK98fIWRAfByB6--
