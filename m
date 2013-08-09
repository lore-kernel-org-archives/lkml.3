Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967655Ab3HILrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:47:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34550 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3HILrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:47:11 -0400
Date: Fri, 9 Aug 2013 12:47:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130809114708.GA6427@sirena.org.uk>
References: <5204BFCB.6020800@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OqXX2KyyhehiiWxy"
Content-Disposition: inline
In-Reply-To: <5204BFCB.6020800@nsn.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regmap: fix regcache_reg_present() for empty cache
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OqXX2KyyhehiiWxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 12:09:15PM +0200, Ionut Nicu wrote:
> In the initial case when no reg_defaults values are
> provided and no register value was added to the cache
> yet, the cache_present bitmap is NULL. If this function
> is invoked for any register it should return false
> (i.e. the register is not cached) instead of true.

Applied, thanks.

--OqXX2KyyhehiiWxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBNa5AAoJELSic+t+oim9FRMP/3I+AXHYY/SPFIEUQillGlWn
mMwcY3/BrV3vi6/XTv1TwLQ7EFCGs2ii9FXA9vtXFdN5i7/40x9FjsKSQm8Y7LxT
rwhNY4Mt2FY/B82wz8YgnU2QEi6Kw9eChmcuUSikPm2Q+aMgsPDHQTei51UfgfVs
rLYrUgRB1l0PVDioWz4KeXGy7TLmWQWcFZrc56jhIkbMnEmdK3e+Z0ThC2w18w6P
9yV48p1PYx43erio7eiB8XxReTrKQ0jamusflotFJ+HU/u3oUIePTTSt/p9+ehyd
861QHsAqbRM2KywYY5JK7x+pbvc66xPmRqIwOzfsjW31zB6jzG26j12q0Jz5wbAT
Q0WQb4Jrk11knpHqcZYS+Z8ReXiQbFppxgjwsWT8/RS6rmfwN40NsXEzkLg2Fb/K
KbAsjEHj61wQS2CYZf0jfySXFGnKJcV7h7jk/oLEt87n/GLKAM7Vc+Vin3rcH77A
r5mHWGrAqHSbFM7J2ZTOyB7z9qW4U4VmLlE5OUaY/E1ZLxq2k1Nfl0Bnzcjgv5Ww
5YwGWrAU5T8cFNYRO3VJLNVcJ0Kw8JJW4ju2IHJh17bVRzqD6NpRyuEfY+cYKAjX
I4l/+D/w/KHRpht8IIhMDHtqNi7IV1ahT45fa6B+V9AAnJtX2w30fmOzqkJyLqaK
5ej+/S0wFSsTMYzZxjDa
=HjJZ
-----END PGP SIGNATURE-----

--OqXX2KyyhehiiWxy--
