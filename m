Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaDXLet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:34:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43739 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbaDXLeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:34:02 -0400
Date: Thu, 24 Apr 2014 12:33:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net, linux-spi@vger.kernel.org
Message-ID: <20140424113346.GM12304@sirena.org.uk>
References: <20140423224035.1de64093@gandalf.local.home>
 <20140424103329.GL12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tE5k6OWzvhsAuKlL"
Content-Disposition: inline
In-Reply-To: <20140424103329.GL12304@sirena.org.uk>
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


--tE5k6OWzvhsAuKlL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 11:33:29AM +0100, Mark Brown wrote:
> On Wed, Apr 23, 2014 at 10:40:35PM -0400, Steven Rostedt wrote:
> > Running my ktest.pl tests on all the archs, I stumbled over this for
> > 3.15-rc2:
>=20
> Applied, thanks.

Actually not - I already have a fix for this in -next (on a slightly
different branch to the one I looked for it on).  Anyway, it's fixed.

--tE5k6OWzvhsAuKlL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWPaWAAoJELSic+t+oim9dC4P/iEq3qamrp69mFvR1QOJKLrx
lJrXD3lH35LXV932MXQoAVAZP7tQ2iCSIBi5EuaFzzsnuLtWejb5wHqLMo+mcC7q
jo82VM4nrCYX5BGk9lVCwSsPW/4HmFiHCBja8SB2up469KehFmm/uqYqacixeg+i
eSBfJq5e4jFrMsYTuXQVPmTxFHa8uulCU6vYPavB2c6ivMBQujnhSfWDa6520F+5
SAtfnxzqpwuIV6mR4Po6oZBL/KlnnDdUnumwyViooTGMKFhLC4XnLB429/I1T0V7
lPdGbarvQje/Gh132FoJUqnqO3d4BkY6Z/fFkKslMdUYTHT/60+d+JaxN4KHD2ok
X/cnLKbcJykot6c/mAmZXR2TSYm0tFTRWa66lQZZo3QmfAphKh718oxttli14Mvl
uaNCSEQ955bdT3XrAY7zAAvl2x9eCebYBiLIsSJn+bx/KDK8WU9HfwzwXKDOYTdk
MKOYP55CHup6xa0JsafmkmgVibcps0UmVHx20tWo6UTS8CcR/tbHVy5hv0AiClSg
XwBUOpSd1bKNqky1Y+tJb3BOrLJpU+cgp0fnGL0MxaW5Ha18rp9OmgJKJyRHS3V4
O077uhTgSaWfvhulgcSWoCHddsvT8ucUIa/E5UveOuYIoiHtq1x4QXsyFwVxjOZA
86bbmL7xM9IcwpRBb2Og
=4Zc/
-----END PGP SIGNATURE-----

--tE5k6OWzvhsAuKlL--
