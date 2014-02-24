Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBXFei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:34:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50558 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBXFef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:34:35 -0500
Date: Mon, 24 Feb 2014 10:40:32 +0900
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140224014032.GT25940@sirena.org.uk>
References: <1387802491-14513-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xv7amlAwsSkXZCHE"
Content-Disposition: inline
In-Reply-To: <1387802491-14513-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] drivercore: deferral race condition fix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xv7amlAwsSkXZCHE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 23, 2013 at 02:41:31PM +0200, Peter Ujfalusi wrote:

> The proposed solution is to try the deferred queue once more when the last
> driver is asking for deferring and we had drivers probed while this last
> driver was probing.

Greg, this patch doesn't seem to have been applied but it looks like
it's addressing a real issue and seems like a reasonable fix?  Peter's
analysis seems good to me.

--xv7amlAwsSkXZCHE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCqMNAAoJELSic+t+oim96aYP/2GU3RnBkVJbkV5num01Ggb2
wob0CUX1TucJEJwoZQIToqEVjzlqHNHA/Tf/FadWSWWGpFTYCL+vRawlVpTcy27X
8vBVG+HAQqWgOmtgFUEtrNJx1eVMs44B+e4jiTyJPtzuwVh6tmqgcj5zD5CdoCvC
sDrbxTmxS37lA9LjF6uRTXbsa6+M5sJvH49/EoQsO0Xkov0+w2ljufPkzzpv1WAe
zQZIkwYgdO3nWzzBsnc+xCQwaP4TuBxYyC407RQzerCwDUIKnrBa8+zkvn+69sSG
qVKFptQNt4ltJsWfcHZ5i9ath2r5VHczSNSfprI8sHyPAawiP/z9cs3sXR9bZMa1
SDl2BTSJGQbjWgwJa8iI+ArTEznDWlvwjiFmJIC5Zjj+GVtvr2/zIMpYA3eXxuic
o4ExpMonGPr80kh8aug6BnpLAWuyTSThRGKHXp4x6BF/AHHaiPO9tDt9SdyeDKU4
G0Yyin6gQVdmYNd9HXvodUuaiY5xWvQ7oR/AqVHTN6yJJKWMnrhOGw01HSDg1Z5k
zC/keDMJZ20QXCkk34cBF8HoS4XCzmd67iThadeQC6IpwCnL4JP9q3SW4fn3+Rv2
GaYmoGnPNsE1TBGvY5SVa7334BOJt10UgnMbhDy4vK5lBoSSfUJmm7LfEf64kL2X
sHEDxXRTipEL2WVTs32w
=2iXS
-----END PGP SIGNATURE-----

--xv7amlAwsSkXZCHE--
