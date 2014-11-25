Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaKYU3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:29:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38468 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKYU3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:29:38 -0500
Date: Tue, 25 Nov 2014 20:27:22 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141125202722.GA25261@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <20141125184304.GK7712@sirena.org.uk>
 <5474D35A.3000601@linux.intel.com>
 <2580837.YI0IvfXqRR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <2580837.YI0IvfXqRR@vostro.rjw.lan>
X-Cookie: Sell by date stamped on bottom.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 09:31:27PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 25, 2014 11:07:06 AM Darren Hart wrote:

> > This is a current topic with the ACPI working group. We have the
> > following document:

> > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

> This hasn't been discussed a lot at the meetings I attended.

> The bindings management process is being set up within the UEFI Forum, but I'm
> not sure if/how the existing DT bindings documented in the kernel tree are
> going to be covered by it ATM.

Al Stone (CCed) pointed me at the following two documents:

http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf
http://www.uefi.org/sites/default/files/resources/nic-request-v2.pdf

(the first one being the actual process in so far as it exists).  The
process appears to be to mail requests in a specific format to the ASWG
chairperson (the address is apparently supposed to be awsg@uefi.org).
It looks like all the properties are expected to end up in one or more
PDF files like the second one.

My initial thought would be to require that we send any DT properties
defined for devices with ACPI identifiers registered there and hope the
volume doesn't DoS them.

A more defined format for DT documentation that we can script into the
ASWG format (or vice versa) might be helpful here, and we should add
notes to the DT documentation if this is how we want to proceed.

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdOYpAAoJECTWi3JdVIfQxkUH/3ucwBHvyyGmuxNn4Qq8YRBo
qQ3b6rSsRqYgGZh/DaM0pMh24o4Z29th5xyM+6IRAtAsGNxkvVhlb+fckyCGrCi8
TcWmofOXsT6vyQ6dJuLypDZwcjSAYYSfdLu27r1ZXKyXKZQrHongQyUD4BiYtlyN
H0gh3mtTNLoS3HErB8OTM0s51L3QsU17/Hmt3ntPIixXoHCE5o2A+3AOWthhy50S
1EV5PxFGX8k77UVzpFD7WKCuQ53YuccPxGXwEgCqFOygmXaLlBMOimOHLVvhRu87
3My2Lyeo9vebeE9D3QT9WruCAkdqS7shphSzs5318OLihHqstOiisnM7iCfFdm4=
=x5UG
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
