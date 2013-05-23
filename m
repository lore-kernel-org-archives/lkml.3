Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab3EWQGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:06:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51367 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759266Ab3EWQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:06:08 -0400
Date: Thu, 23 May 2013 11:05:58 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>, linux-kernel@vger.kernel.org
Message-ID: <20130523160558.GB7660@sirena.org.uk>
References: <1369322629-25157-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <1369322629-25157-1-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH for 3.10-rc2] regmap: regcache: Fixup locking for custom
 lock callbacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 05:23:49PM +0200, Lars-Peter Clausen wrote:
> The parameter passed to the regmap lock/unlock callbacks needs to be
> map->lock_arg, regcache passes just map. This works fine in the case that no
> custom locking callbacks are used since in this case map->lock_arg equals map,
> but will break when custom locking callbacks are used. The issue was introduced
> in commit 0d4529c5("regmap: make lock/unlock functions customizable") and is
> fixed by this patch.

Applied this one as well.

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnj5jAAoJELSic+t+oim9D+MP/j1GBBj1uUiECVYpuVoOaS/2
er4vzJFqZeKtmTY16b43zKx2ApUHvIqT3c9dbiBdx9Xc+xn1HSu7TJQ2t5/9xrim
9eEXdRmC1SgGfsyHUbCthhacZzr0+SjjPpOsS3FtCuf10t5gV7bJkP7vK0BWvT1v
TJoBzfedgUpO9bA2uiSF5ZbugnxnupJpeIoJMeMIEcMfwJhQkZMgHtOFwzvly0Gf
dyxbCsk66Y/Kv7DFDPWUBGU0r+SqMrVlztjOc47Jpth1AWtR5gYCwLJlD57u6Hh8
tAIMYZ+C+8hd41Fgl8hzBNOQLBkchF8VJt9LkAPJ2L59VTN4JrfahWk+Bdidhv9I
2aGTl3clVLDZRHEZaIC6wTsfYVtGQbveFAJISs1VPofw6NHzbizmj8uATgBrUz1Y
tTF7MNTC+Q+3A6cO3moITm0R+SOVNp9EN9M+NbvZCPRLu2v+koDTYiQdQ9qu2NI9
NfPMoXYvD+xyZhz5lKIyuWvQoAQQ6adgX0QSXfok5L9xoW64P3jSEHREI2kxs/jR
2SsiQs19NAQSUwLiW+1kuYtmxxv5QbgkaKNoAggXCz42PHAu7UXFqa9On8Ue0ngL
5HhWLna/Y0zUyLEq9v1mRFJ8SB/07BaJFU9XNUAvVtRBgvYaGscP8uYIbdwO74yy
Lh9VMrIjFsHeYP6iFj6z
=lqPr
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
