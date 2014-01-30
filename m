Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaA3UuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:50:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33053 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaA3UuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:50:14 -0500
Date: Thu, 30 Jan 2014 20:50:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Message-ID: <20140130205000.GX22609@sirena.org.uk>
References: <1391108240-16161-1-git-send-email-broonie@kernel.org>
 <1391108694.2422.59.camel@joe-AO722>
 <1391114256.2422.71.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6JAe/4X0qssghT2u"
Content-Disposition: inline
In-Reply-To: <1391114256.2422.71.camel@joe-AO722>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pinctrl: Avoid kasprintf/kfree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6JAe/4X0qssghT2u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2014 at 12:37:36PM -0800, Joe Perches wrote:

> +	char propname[9 + sizeof(int) * 2 + 4] = "pinctrl-";

I'm not sure this is a triumph of legibility - there's several magic
numbers there and it's not blindlingly obvious where the caclculation
came from.  Is this really a hot enough code path to benefit from an
optimisation like this?

--6JAe/4X0qssghT2u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6rr1AAoJELSic+t+oim91lwP+QHDsdkkRD7rSi3kT4/JjN3y
np34UjR52gWCkGkju8EQYzPEuQVwYXHaL80cFhVtIUUxuBbaiK7mN0vgj6+rkxRg
xxhisuAIEK8G1T4BCs1eXjqmbf3QbxYoqbHwEXrWqOOJzDT5ql7QDZrJnPY4Igtq
HmLqhFEPIBf3dMb99YNuJPcVRieBdFn6HtgnUxNBqgw7sCxDg+jcYaicpWOs4R//
pfswoyfQCyeHnI2+FV08wExxtDixQeP0cDgBDgPxBnTb72Ww3UOOgVA/KOhPzSpu
d6wVDAxWu5QJVbJvK5Nq9nuNtFx95qYydbQqprJBiYyJ1+YZ0oSmysulBG2Y7jWp
GagOrNurwgmsDcorn7eHnAXJbTIzaYXC+uuMSsG/bmHrt2NJCn3LwTyblMb1i3na
NMTZq+Jm+dec9HTF3+F3GD2wC2DVc9OswqKkpsUNEU0QJgoUjCUKyTS/08IwEvJf
LU61ap7exLSXasCqFNAPt0Njai1xBhuMCnSxfpOzb1jJmaRmCn/oAvvd1yMSvJWn
1ceT09PSUCyzDhKaCqsPPPhlFtdy9R/fF+FdylDySflX5Jzeh8I1m5LMxaxWRg9h
pWYVhjCEcvmuPgfL90Ey85d7zqTZq10K1M9eCs16Yn134D1QKq2wbooCVq0NxYRD
lP06lWUZxfCkIUAZKnI/
=n8mx
-----END PGP SIGNATURE-----

--6JAe/4X0qssghT2u--
