Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbbAPQ2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:28:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39771 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbbAPQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:28:37 -0500
Date: Fri, 16 Jan 2015 16:28:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150116162827.GC3856@sirena.org.uk>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
 <1421419194-1849-3-git-send-email-p.osmialowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <1421419194-1849-3-git-send-email-p.osmialowsk@samsung.com>
X-Cookie: I've Been Moved!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/3] i2c: s3c2410: Adopt i2c-s3c2410 driver for new
 enhancement of i2c API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 03:39:54PM +0100, Paul Osmialowski wrote:
> This adopts i2c-s3c2410 driver for new enhancement of i2c API that
> exposes preparation and unpreparation stages of i2c transfer.

This doesn't seem to have any dependency on the previous patch at all...
it probably does want a better commit log, probably the subject should
say what new enhancement of the API is being adopted.  ("Use
prepare/unprepare transfer" for example.)

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuTwrAAoJECTWi3JdVIfQAAMH+QFSastTtArNA0Tft9MK4qm5
HdnPNzh1PhvNc4nQy92JWbERfd4WFxa+G2T4AUKejyREo9zbwMwWbRIiqoiO83D+
s28MTdiaZn/mVt5jDAvcegEkmmQxuiAIFDmfflmC1uJH++59ipptaxTl+yswnBgk
W4lFt/KAbz5oOMFOJngO08U+uzqRaOXnyecpFuee6JMgi6dx8OCqPIjUgYPG1D++
I41ISYGd9CrrWZv/mu87j6KU8kXqIwAwiM+zn+jjqPZu+k+UbssHJy2CEB+Cz2dU
iAarBhI9U2pRggGYdKSfjwQC31qnVymRP4PduqFgiGgT1+T4oa6/Qz1VTReoV44=
=nZB+
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
