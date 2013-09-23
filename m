Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3IWXdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:33:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37345 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3IWXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:33:32 -0400
Date: Tue, 24 Sep 2013 00:33:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130923233307.GN21013@sirena.org.uk>
References: <1379846854-11746-1-git-send-email-lars@metafoo.de>
 <20130923101551.GY21013@sirena.org.uk>
 <5240A46B.3080408@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aavXWXnpRwqpjJp2"
Content-Disposition: inline
In-Reply-To: <5240A46B.3080408@metafoo.de>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: of_get_regulation_constraints: Use node name
 as fallback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aavXWXnpRwqpjJp2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2013 at 10:28:27PM +0200, Lars-Peter Clausen wrote:
> On 09/23/2013 12:15 PM, Mark Brown wrote:
> >On Sun, Sep 22, 2013 at 12:47:34PM +0200, Lars-Peter Clausen wrote:
> >>If the "regulator-name" property is not present use the name of the devicetree
> >>node as a fallback.

> >You're not supposed to use the node name for anything, the goal is that
> >it's entirely ornamental noise.  Which is a bit annoying but there we
> >are.

> Is this documented somewhere? I'd be interested in the rationale behind this.

I have no idea, I've not seen any documentation but that doesn't mean
there isn't any.  My understanding is that the goal is to allow it to be
freely used by the DT author without consequence, though as you can
probably tell I'm not personally 100% behind this idea.

--aavXWXnpRwqpjJp2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQM+vAAoJELSic+t+oim9oU4P/R/5I8vzCmzTIv8nBYM64mHF
rUHpju3w0VXSU3or3PbhMRAuVplDU4XTNLHdCjckhH9ubXbWAT87nutB0VSIoNrf
OEFkwyfQcPpAnwCA9c5idlwh4NWDZbAhKVKN+N57tnpuf076wCPpxipAbjlhdrBy
oN+SbZl6J4ZVQ/WftIov6l46lxeXo4TUMb8AIsLdoAmrKUIc3OpgKyWbPXo0aMOz
BOx7ybXHf2q9jdbKhnBS9KJS4hXzaK70JEaysp0eyMEHzcMo0jQwaUn2yhh9k+KQ
sS6XHx+md6n9zISpFEu8jxYYMy6CqfQ1X4FFWLGj1AEgG0Mbq834ziIzwE3Ws+5Z
OgfwbTFUgrBhR6GBuUHhu8f88lCLRLLR50RLilb/sYjimGA+lZA5WeoEcWA1aq++
/hzwP6eFU2819t/a7oviM+7OnYlAjWMkrc1lbGKyzb8WSN/wM1LeTL/5q1So9lpc
uuVVBzT4ycsicOhFakFLlbAfcwBeHaSgNVrVXJ8YPULHat7tGFdAwT+t827KmqYu
Dcd90f39x7X8Nry8ybKDwjhrQ6aq8CnyNsgKCQTFN9QqL0BXyYk+chUdeN8eAwY/
qEyV0EGM7b1DgYkxiZju7AifEli7Y+fHtt9jeZUa4LBigt9E9+shF/qwrOYbFtYD
827v/B04wfaPJBv6mm3+
=u0QT
-----END PGP SIGNATURE-----

--aavXWXnpRwqpjJp2--
