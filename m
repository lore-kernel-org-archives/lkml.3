Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaDXKdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:33:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43699 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaDXKdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:33:44 -0400
Date: Thu, 24 Apr 2014 11:33:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net, linux-spi@vger.kernel.org
Message-ID: <20140424103329.GL12304@sirena.org.uk>
References: <20140423224035.1de64093@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cjvfPnFZRrNVeVma"
Content-Disposition: inline
In-Reply-To: <20140423224035.1de64093@gandalf.local.home>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi-bfin: Add missing gpio.h include
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cjvfPnFZRrNVeVma
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 10:40:35PM -0400, Steven Rostedt wrote:
> Running my ktest.pl tests on all the archs, I stumbled over this for
> 3.15-rc2:

Applied, thanks.

--cjvfPnFZRrNVeVma
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWOh2AAoJELSic+t+oim96wIP/10wKxXpZnvcov0aFSd6tz8t
hjoCVt8YdK2DQqTqzY8e3EXSveFC7zJfGIXekE+Hu3ndGzhJol/pPYA9aMwQRUf8
CHZbLYiHc3kspbd2yC97PcOBSNoLNYHgfWCyxVN1dMM6rWffB3MYynMwEfFQLtJc
c1N8AhRJCcdxC0f+aL+C+0K0ml/jpUGer359fCofJAPrNGlF2136ZWeJ2GE+1u+w
5vGlGH0Rh7v/gM/PfYPti4noBb1VQlh9hd9PJLi7rmqGGF7Gh4Rk2esB4Hnosbe5
AppIXV6hecYVd7tkh8+++3bwAxK4LvBxK7MSsYq8Xq/LtU3Ng3TFoRjblB7fXDPY
CAFW44nLEDiCqI3eRowezppeARCn+r0AseLOU/SvejhyN9rcgPANS7mIcBzP/1nO
hrlb2zagSKl+2Wn+vrfiCoHddQfuzjGFEV/5GgFFVBe34qEvaBY+DiC8MpQdkl9W
dZZBYcGhRqRaAhOsrPK/ITyQhKlAyeP8otsgKPmNwSrVMTG9TnAB2uWpz9eywPqw
6A1vGe7JD7Ngk1mhz2mOkSTvVNX2q1gRKnX3cEvTTeJ9p3y8s6O/jQJ3d60C43ET
DGFyZhoU9JJ/VyU+alveA3YqtyMaD1i7z9fzpju6ZLiClSGHjFy4rtb0xseuGmNz
v8G1l8Xo3F08eYAPcuu6
=JXkB
-----END PGP SIGNATURE-----

--cjvfPnFZRrNVeVma--
