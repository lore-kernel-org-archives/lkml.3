Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaJALPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:15:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56335 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaJALPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:15:15 -0400
Date: Wed, 1 Oct 2014 12:15:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Murphy <dmurphy@ti.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Message-ID: <20141001111504.GR4273@sirena.org.uk>
References: <1412093220-24690-1-git-send-email-dmurphy@ti.com>
 <542B1ABE.5000900@metafoo.de>
 <542B1E38.4020702@ti.com>
 <542B20BE.3060200@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHJAUhyIZkPvF01C"
Content-Disposition: inline
In-Reply-To: <542B20BE.3060200@metafoo.de>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Allow read_reg_mask to be 0
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nHJAUhyIZkPvF01C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2014 at 11:29:34PM +0200, Lars-Peter Clausen wrote:
> On 09/30/2014 11:18 PM, Dan Murphy wrote:

Dan, please fix your mail client to word wrap within paragraphs.

> >The device, which is already in production, has a specific control register that sets either the reading or writing of the rest of the registers.

> >Here is the data sheet

> >http://www.ti.com/lit/ds/symlink/afe4403.pdf

> >See page 61 control0.

> >Driver is written for this part just want to get this lead patch in or maybe an alternate solution.

> Looking at this the generic SPI regmap implementation might not necessarily
> be the best thing to use here and you are probably better of implementing
> either your own regmap bus or reg_read/reg_write callbacks that
> automatically set/clear the SPI_READ bit in the control register depending
> on the operation.

It definitely needs more than just this change at any rate - any generic
infrastructure that tries to work with the regmap is not going to know
about this read/write register.

--nHJAUhyIZkPvF01C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUK+I3AAoJECTWi3JdVIfQ8bIH/0OQ1/OtzBU0/Abq0QR1IxhN
GXYaL87cfOB52sCjyczfq1pO3sW7l/zRzyCI8IRzT0Q2l6LgzFFanhK/MKQdTiE1
DiQ3uxX1/GMNAcfp7PfIlxr+ohec3RKo549nXOED4SWZ9TOJgJhabCgzLjD7O6z/
yvUKqtpFHhh5Vj1iTq/2eMi4VjyE14AET3ww6Eb9TrrtCjMJLAbNDUfiWyQRpuxV
r7meSaUzjO+WOKM+3CF2W3VkXyYrkbWxL97e4Q5e7A09SI3MDuZRUKpT0zXUXIQr
zoASwba1MyEaa4q4Jz5kdoJTqz9Xqn4dvirQ3ET3RxZaFwRMVf3PJ5Zi7xpXS+I=
=+Avc
-----END PGP SIGNATURE-----

--nHJAUhyIZkPvF01C--
