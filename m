Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaEZNjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:39:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43131 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaEZNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:39:23 -0400
Date: Mon, 26 May 2014 14:39:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Message-ID: <20140526133904.GE22111@sirena.org.uk>
References: <1400890613-5704-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H6jlV0PUznCT28/J"
Content-Disposition: inline
In-Reply-To: <1400890613-5704-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: pxa: pxa-ssp: Terminate of match table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H6jlV0PUznCT28/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 05:16:49PM -0700, Stephen Boyd wrote:
> Failure to terminate this match table can lead to boot failures
> depending on where the compiler places the match table.

Applied, thanks.

--H6jlV0PUznCT28/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg0P1AAoJELSic+t+oim9LmMP/2dyQHBIGO1F2XvCFOYoV9iq
3M/gASsTCyt8V96BQTeY4zeQAwUcMFTjLKSnKKhq4rsA/ZIqosJ/8nYe5x9poVEV
oOyjsaGaix2+lmdUQWmPLtq0wbGKIJxiuVCioZxZ/x2voLEQCnfRczMRs0HTY7pv
iJ5/Ic/CP4vN5yWB2Xi0tcwEnVkd/XpI/eBfvxv7PMOe6Um+xEFyF3vLFDfUPL7L
6T2Mgagiu+4R34g2BR6ZVbZJMyhDgEIqH6mm+Xoxe/mHx5l2NPuPfTxDMmQyXRTR
yfYENg2VTBRqi8W0a2S+LqyHzE7E9lLShf6n8UIBO6WR1YeK6n4qHUjHdPd2Nb0d
r19BRZEoH1NSK39GsZyfSUBLvDQlhz/cDAAAFG0ig/RPnlCzFqEOYz9YW00HW+VV
q2ujFozvb5ZkH4LG4PnTzr01DuSUFfNQAM1nOaQFJswpuXDMHsEn7pxX5ntn8h6a
6vttFgCNC3j3f9hLV2iBjwRTrsIoe9wOBQJnFk/DOca/QJMgwy5dZYbJBJTS6/J5
J8J18ffShKRzXPPKhgNDMbDGSY8l8vozaGfQGc3bKzfmGiE3qpdfyjpA6L2pVsFf
aExa/xTy0RvYzS2zyHQNUuj/COYEf8APAGh/BHmCNLCYw+apRAJe/1iexDKiWtQn
FtUtNHE7tqu+23AS2zEf
=2sDI
-----END PGP SIGNATURE-----

--H6jlV0PUznCT28/J--
