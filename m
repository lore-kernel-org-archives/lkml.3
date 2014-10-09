Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaJIAMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:12:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaJIAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:12:39 -0400
Date: Thu, 9 Oct 2014 01:12:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Message-ID: <20141009001213.GS4609@sirena.org.uk>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
 <20141008234541.GQ4609@sirena.org.uk>
 <20141009000555.GA27476@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oc4Z9ongRuk6y2kD"
Content-Disposition: inline
In-Reply-To: <20141009000555.GA27476@roeck-us.net>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oc4Z9ongRuk6y2kD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 05:05:55PM -0700, Guenter Roeck wrote:
> On Thu, Oct 09, 2014 at 12:45:41AM +0100, Mark Brown wrote:

> > definitely at least add a boot argument or something to suppress them,
> > let me have a think if we want to do that by default.

> It is a nuisance, so I might just disable it in our tree if we don't
> find some other solution.

We'll do something, just a question of what and what the default is.

> Did you notice the problem with debugfs I had mentioned earlier ?
> With all those regulators, not all of them being used, I end up with
> many having the same name. This causes issues with debugfs, which is
> trying to create the same file several times.

> Any idea how we could solve this ? The constraints message is annoying,
> but this one is a real issue.

Shove a dev_name() on the front if we get a collision?  I have to say
I've never cared, the debugfs isn't that important so it doesn't matter
too much if it fails.

--oc4Z9ongRuk6y2kD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNdLcAAoJECTWi3JdVIfQO0gH/375904cx2UyWec9ZZd5Z++2
0XrvUX6OnzXZjrvEI9zQcD/CaTrHWNkNJ9CNp3vmKAOR9XrXS13YH5vuLFqlTlX4
wF0dxORaYmUziIY0zIyUne/lwo5a7YufxmIr/mVr2Fa52cv3IfZugQxMjlGXOBAF
0Pna0DM542EY5mHFcqISQ/RLZ3/YHHfV8Ls5+FHc7jsjIcxB0fyAuVZzsq8TuJgC
kk8s+V7XmYz8J05nvERwHID3/gYkJ0+eTV9UecGqFU0sKKqxypnMF+LubtYQGZMR
1SchoEU8eTytFz9LEPn7nWhngLrS/mCbQfb2SAd46Q2GkVS4Lk/JzQmux25Yf+Y=
=/Fdn
-----END PGP SIGNATURE-----

--oc4Z9ongRuk6y2kD--
