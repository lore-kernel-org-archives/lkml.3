Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaCIIF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:05:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55887 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaCIIFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:05:25 -0400
Date: Sun, 9 Mar 2014 08:05:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20140309080516.GK28112@sirena.org.uk>
References: <1394271066-25380-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OqZxW6Yu4sgZZmrd"
Content-Disposition: inline
In-Reply-To: <1394271066-25380-1-git-send-email-jcmvbkbc@gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tlv320aic23: add missing EXPORT_SYMBOLs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OqZxW6Yu4sgZZmrd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 08, 2014 at 01:31:06PM +0400, Max Filippov wrote:
> This fixes the following build errors when aic23 is configured as
> module:

Applied, thanks.

--OqZxW6Yu4sgZZmrd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHCC4AAoJELSic+t+oim957EP+wUUt4sTwT9kmgYPfQS14qqm
bDA0B5+zTrdho10szfSVAiF6uStLsxSyhsxqm5YZq7sZfcxcL8Oy2pG2Fh+25ZPR
BXLkz2bQXx+WYjhp/HLS2omfICDiN+jVIIg4BKE5atXHuGc9hDDGXCm9URhhSPmE
2qX3ObMxegLp4ZkLNt73TzOr8T1L6DBds4+/GjNJfBk6rRF74al87OPq7iyQFdoN
BDsPb2XlTbhH5mCujzJ3IWFHszlPZZU04h6MhKWH/3m74bYe1gyrBOr6F57G4/9H
+eiGzoA4YnGTiwIgvbr3DeGZhoDL4k4tOC3A95QKE7qrg2aYH/SAKHoMJKOtAAf+
iQ4O4tHLnfdha6jlOr3QLAQfYZZKmjJH/6VfZegCQu3SC0Hb4Pyyh8STFjD93Phe
2ou7OB5McX6iuGC2u1lH9I5rtWe0wJC9BZdjBlqu0t0xUEzqikiPLBvblDNLIvMe
l9vfuAQe1xkM9RmBB1QX23uz/jG3XpFUTGbKBQzY4m7dEjwganoJnao7DpHYT/IZ
CcW2FQ71wTg67UGsAkkR7Bje5SKkKoXj02UKG8k6KIp2TkFA6oLJaYphlyJ8OJRF
O2z504Si7un812mDrQS3w875X4TloHUbNmRO7N2QnkCUSnetJtfbF7WiU8Q7UONZ
ZRfVGGmNfaGJfS9gfKJp
=dgMD
-----END PGP SIGNATURE-----

--OqZxW6Yu4sgZZmrd--
