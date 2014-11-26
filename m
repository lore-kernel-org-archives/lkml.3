Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaKZLTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:19:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39222 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaKZLTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:19:31 -0500
Date: Wed, 26 Nov 2014 11:17:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Message-ID: <20141126111716.GE7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <CACxGe6stjCvaQZkh=hFcF-56v5qJVar11jRZz0PRSd2wz6EUyA@mail.gmail.com>
 <5474A78C.7030805@linux.intel.com>
 <20141125172120.GI7712@sirena.org.uk>
 <5474CB5D.9050807@linux.intel.com>
 <20141125184304.GK7712@sirena.org.uk>
 <54753168.9010303@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4mL5lf+nIvB09VHj"
Content-Disposition: inline
In-Reply-To: <54753168.9010303@linux.intel.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4mL5lf+nIvB09VHj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 05:48:24PM -0800, Darren Hart wrote:
> On 11/25/14 10:43, Mark Brown wrote:

> > Link from where - do we want to talk to the ACPI/UEFI forum and
> > figure out some kind of fast track process for them to add an "it's
> > already covered by DT, see here" entry to their database for
> > example?  We also ought to work out how to make sure ACPI IDs are
> > registered there as well, should be possible to have something
> > simple as part of that.

> As to registering ACPI IDs, I believe this is the right link:
> http://www.uefi.org/PNP_ACPI_Registry

No, those are vendors as far as I can tell.  I mean identifiers for
specific devices - it appears to be common for for example Intel to
allocate identifiers for devices they don't produce, I'd expect there to
be some effort to keep track of that especially given that _DSD
properties may well end up being specific to the identifier used to
register in cases of parallel evolution.

> Or did you mean a HID/CID<->DSD mapping?

I don't really know what that is, sorry.

--4mL5lf+nIvB09VHj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdba7AAoJECTWi3JdVIfQl+EH/05OwjjXJShHKp/BUtfOENKZ
8YftwVKN6JcxV8bMCirUrmW8SUU7e30SczJCNO1M/6d+eIStGINKidD0WH8xsN/t
frPLB51T2BLbZi66hp4H/SQPUzi1HLK+RvBD1+SnObY04vn0vbQBUgkerBs2zU4G
c3E/uMcjG2ZuMb7bVphC7nnuHs3edz99gyAEGZW9ZCz0uvPqS3BUm7UTIXb5UsVF
fQkOzIZeioRRjw81dSzFV3ruJFMxbxe0Sb5BfoobuGDRBl9ZM32QwzSIZl3pyVdh
KuJTar+zYpgT5sdZWcY+7088uE1aGvHl0Cn+7B0LnrponBT958EibrEqeg3w9cA=
=13eO
-----END PGP SIGNATURE-----

--4mL5lf+nIvB09VHj--
