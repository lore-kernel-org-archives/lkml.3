Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaKXSGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:06:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37021 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaKXSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:06:23 -0500
Date: Mon, 24 Nov 2014 18:04:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Message-ID: <20141124180422.GO7712@sirena.org.uk>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
 <20141124151527.GC7712@sirena.org.uk>
 <20141124181233.53580998@avionic-0020>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yUmmepPgoWmUqRhm"
Content-Disposition: inline
In-Reply-To: <20141124181233.53580998@avionic-0020>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] devicetree: add a binding for a regulator that
 constrains its supply
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yUmmepPgoWmUqRhm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 24, 2014 at 06:12:33PM +0100, Alban Bedel wrote:

> Using this driver the DTS for the add-on board can further constrain
> this supply to get the voltage it need, for example 3.3V. I understand

> I saw 3 ways to solve this problem:

> 1) This, use a "filter" regulator
> 2) Extend each and every driver that use a voltage regulator to
>    optionally set the voltage
> 3) Include the required range in the phandle reference

> #1 was the easiest :) #2 doesn't seems practical to me, #3 seems pretty
> good but I'm really not sure if that would be acceptable.

The DT overlay for the add on board should be setting the constraints
for the parent regulator.  I wouldn't expect the final DT to look any
different to how it looks with no hardware modularity unless the actual
module is interesting enough to have a driver of its own.

--yUmmepPgoWmUqRhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc3MmAAoJECTWi3JdVIfQcb8H+wW0MTogKJyCaC7YefFGslSg
GRAxfsH8dH14IZkbN2jMwrPjoEq0xqKXXQdTfhbqe7Qpy0z6zQR+4gpYR5EjiCxX
x7iKw7o/loKB0ODFAOqGrxg6qopYbKFVm7sl6+f9Yg9dVULLGQ6N535rnNXm3R3t
d5r8WRrN2UzQ0CbTTDRtKqNHhTrWX36AIfQfUKn9zXRZiXpt5JDaRxr1gYbIc72n
BnRzELSjIOXsxZQQukY1bv4zkLzBWhbridC67FceXv1SsX1822xcfSEHab00e32/
3mC9TjczMldjckcVYc2xbYwPQxYj7zc6DM8v8dtkj7WTHLNDUfTvP48Po+LQK2Q=
=JUCo
-----END PGP SIGNATURE-----

--yUmmepPgoWmUqRhm--
