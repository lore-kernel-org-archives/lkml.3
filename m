Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaCMVsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:48:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58174 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaCMVsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:48:07 -0400
Date: Thu, 13 Mar 2014 21:47:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140313214759.GO366@sirena.org.uk>
References: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o605RBccvup4jNEP"
Content-Disposition: inline
In-Reply-To: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Set data pointer only on
 regmap_add_irq_chip success
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o605RBccvup4jNEP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 13, 2014 at 09:06:01AM +0100, Krzysztof Kozlowski wrote:
> After setting the 'data' pointer (wchich is returned to the caller for
> freeing later) the regmap_add_irq_chip() could still fail for various
> reasons (ENOMEM, regmap_read or regmap_write failure). In such case the
> memory under 'data' was freed in error path and error value was returned
> but the 'data' variable was not changed.

Applied, thanks.

--o605RBccvup4jNEP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIieMAAoJELSic+t+oim99RsQAJsTTJnaU+sljg9rXfAEK31P
PMeH7K5LRPtsayAuCINPWz3bW4r+Y/7N/TF3KUjd9qRN4nYfEvNoqTrSzY1MO3NC
3IMjVa90P+o8+CPK8D8jPdEXP2blSB4mM5pxr5OP6Bx6rt0qFMHMTl1GPszPSLl6
k4i0r7KAP624UScaHQhgn7E7WKBabfzmgNqo/RQ+kpiTqB9wqXyG2+LBMbzHMuSE
GP1S6EvfiyZlXNjMWmFstpmlm27BewHg9j0mnRdOJcCSQXI4t1G5dJRACZ7AAb7B
HGz5d/TNasi3rDUBhO/R57tsIoGdNBy6JpwXO1dlKqvk+r5oLucJ2b9dEBXnvNji
vIWHylEWAFTygMa0PBSicSTsx7E2pdKHaDIoFNl33h6DYn+jvYxGSUTSSnfpnd7Z
Xm3+Psw8cJeXAbD7hGw3F5qI6p8rPl3QINEmBTC5H5G5Xs53oEWPGbqJKc5DtzdP
TLfVgZJLsTuUVCj58F7UjQzOvaEtjbRuYkB1+4ghol4O4eyE/aZ8hpgToqGMHKaA
BkynYqJClohzTmmVeYmNNiDyFyWHcCOppwkl/b+oqXdCLrHj9D7td2vJySdW5ZMu
vRSxw9mEpc3yRhht+6jfF+T62pVaCL37x3QHZpRmhHTIayMoRAiq4RvqiDagZK9x
x4t9SMaub/ESWazHHfr+
=+FMh
-----END PGP SIGNATURE-----

--o605RBccvup4jNEP--
