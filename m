Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3A3LyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:54:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55374 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600Ab3A3LyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:54:15 -0500
Date: Wed, 30 Jan 2013 19:54:03 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, software@gaisler.com
Subject: Re: [PATCH] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode
 outside of FSL SOC environments and add a grlib variant normally running on
 sparc
Message-ID: <20130130115402.GE6229@opensource.wolfsonmicro.com>
References: <1356711368-10437-1-git-send-email-andreas@gaisler.com>
 <5108F031.1010005@gaisler.com>
 <20130130103645.GB6229@opensource.wolfsonmicro.com>
 <5108FE46.1030102@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <5108FE46.1030102@gaisler.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 30, 2013 at 12:04:38PM +0100, Andreas Larsson wrote:

> If you would like I'll resend the patch adding you to the CC list.

Yes, please.

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCQnCAAoJELSic+t+oim9OfkP/2nire4ry/vnlYL+M9IK7dHA
URIo2aqnKohX1El33Fnl7sj6NeYSK1jyWG+12mbcCKPhJGFugQtcCEBPuoHmIXZy
7CVBLXyn3yAC+jgP7E/YREd7D4MbD5IkadD0u3hMj5GcyqDIMYiTk1ZBzz7Sjxke
XYU1aX+lyD74CWnhXvm/obkiPljWTaoBdxprylD+fBdqySOkpzmKWlHvVnyBc+xN
uYwiVcLOW23QX3G5N8G0S7cVq2mLpOlaZRLNeKXaaSNaYYe9ocxVbLQ/EQzLl1mc
t+UKmsj5ego46eBMoySnv8D+6Zpz8YONiM879whzri4IyKIc7UN+rUek7tn1zyo8
/IV6cxMK2hpOCchAvek61TLIdDE0QvsNq6Ijzp8AAxa7kr2eldyH8QYfPr5+KY64
ui7T9Mf0s+QKMOI9SykqHLOi89K1N7N+9AghCpGKCmFYQfZruNWaJu23hkvWfkoB
taodH2rOFb9y1Z5PU04Y3HFNILRui38IKJScpseGFk+/roEkNBf988rVxgCjJP1y
NfP0IyoaKfWcrE10VHBKAC+7o6CXtAzXOMbW84PRL33hzbvlNy4biahHZ3f8FBQc
TQIRRZNHheJd9fxyCEaBOf2Z8Y/QRLJRyDNXs+FDu9LAqn3J8rslnjiHSGbqAWYP
RFIGvqrP5UchwI5fU33u
=SIe8
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
