Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaDOJty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:49:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33654 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaDOJtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:49:50 -0400
Date: Tue, 15 Apr 2014 10:49:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michals@xilinx.com
Message-ID: <20140415094938.GM12304@sirena.org.uk>
References: <1397537392-3709-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vdqwC0msT4ilQ2it"
Content-Disposition: inline
In-Reply-To: <1397537392-3709-1-git-send-email-harinik@xilinx.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: cadence: Add dependency on ARCH_ZYNQ
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vdqwC0msT4ilQ2it
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 10:19:52AM +0530, Harini Katakam wrote:
> Add dependency on ARCH_ZYNQ in Kconfig.
> This is to fix the build error.

This is too strict - ARCH_ARM would be fine (PowerPC also defines the
_relaxed() operaton if you want to include that too).

--vdqwC0msT4ilQ2it
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTQCuAAoJELSic+t+oim9xMUQAIAgImDb/5NYjFQA3ARXw8h/
GFhsamaB7LYHt7KcjOArIKzLlfaOsBntxQDYojW7+NRTeoVTyJ3vWwfuUJgQxi1i
yiUzv7Dl1/4lpHpQi56hNuMZv7TyURTzaY12IW1AYPBmft4udApCI4k9jJhrIx+e
J9sr+7HGtbY4WcY3zfWp1Eaz5sewVSD9aRK7EEN5VFzfU/w/EOSodwK8EK1W5bQn
z7ySbytBhbLOOtqY5JIDGeOgFIV8ULrgvD3pMMSkv6mE7HJnAYWHZi9zGQh0dNoO
HkB95j38gqtkfBBMtjetZL5AiR//zzicSKbhBAbdaw0H86EY3yCMtvr2fc/eRUa9
MwvAaox8C3f8mHGfnVBh+YBey3Q4sVR6ndTYhN8l7hfOhidOUZd0DtoztwWi4Hm+
xnldiOF4p1/sKBbxDiKgTLBnGTXINCdcLAk4Qz9xek9WNHY3IOgqqKe4kO0IK7v8
KUh2ygrf9f5MeZFfe8Ms1HrlXuILMkB2lHRNLpXGrQsNuO9s+7r3IXbE7tsv5xoL
w2sm7NC9F/g18HzvoeLCcyX0d9epFnv+FiKrrfzjoLfX2K60pbLaoIz02p2SpjCu
ND+wiVU8DxZElA8UJtpL8W6rAvoZzirKp4lUpawWjLMK1Jn07S3F82nwCuLQ50Zs
zXSim0ymrIld1YhijeVJ
=V7IL
-----END PGP SIGNATURE-----

--vdqwC0msT4ilQ2it--
