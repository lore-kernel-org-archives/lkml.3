Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbbAYUNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 15:13:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33687 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbbAYUNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 15:13:07 -0500
Date: Sun, 25 Jan 2015 20:12:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Esben Haabendal <esben.haabendal@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Message-ID: <20150125201254.GX21293@sirena.org.uk>
References: <1420472564.803.9.camel@gmail.com>
 <20150105154834.GV11764@sirena.org.uk>
 <CAOR3GqUBWyfUvNG-8JiPVkis6b_25Eq_REtcp=kLN3CUoqsG6g@mail.gmail.com>
 <20150123124529.GU21293@sirena.org.uk>
 <20150125173853.GA6467@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/cFG30PKHi9lwv6o"
Content-Disposition: inline
In-Reply-To: <20150125173853.GA6467@kroah.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Backport of spi-fsl-spi bugfix to 3.14.y
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/cFG30PKHi9lwv6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 25, 2015 at 09:38:53AM -0800, Greg Kroah-Hartman wrote:
> On Fri, Jan 23, 2015 at 12:45:29PM +0000, Mark Brown wrote:

> > So, I now see this has actually been merged into stable without getting
> > to the bottom of why it's helping anything...  this is a bit worrying
> > since it's adding new functionality and not really a bug fix.  It'd have
> > been good to at least get a followup here.

> Do you want me to revert something from the stable tree?  If so, has it
> also been reverted upstream?

The patch just isn't an obvious -stable patch - it's adding new
functionality, not fixing a bug, and I was surprised to discover it had
been added as a result.  It's fine as new functionality and therefore
hasn't been reverted upstream.

We can probably leave it there, though if this is OK that's a bit of a
change, but if this new functionality is a good fix then we're probably
leaving other systems unfixed which isn't good, I would be very much
happier if we understood what had changed here.  If new functionality is
OK there's a probably a bunch of other changes we should be pulling
back.

--/cFG30PKHi9lwv6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxU5FAAoJECTWi3JdVIfQeEsH/ipnAy0CGkCv480YmZDjNnPD
VX6o5p+GAYKN/tLhwpYlo9y3zWcapoZsLpJmxOrztsNjCes7vIC3g7eu1776mXyF
hg5Qu8jszl63V1ZiEEXL9gv6CNt63p/bEiQXTnfdzta9zQx8mLqIxcAdVuF8w5BD
89c+H6bsYB2WCnXRq+MFiaRKK0SLW0syINW0XGDRyabNM3kSGzpitN9YN99U9Tll
YLV63kCSOThQPCg5f5sJ9S/SaeQioCaQWorwvzSUV5VTMbte6tPlx8EA55K967yY
tWFJSNFzbe0hDqfqs9RekkFdh79ouv0oEtNhcc3v/ITVk1mSpY9yBaPaaJJUpmk=
=/z9D
-----END PGP SIGNATURE-----

--/cFG30PKHi9lwv6o--
