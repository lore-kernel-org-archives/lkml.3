Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbaJUV2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:28:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40644 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbaJUV2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:28:02 -0400
Date: Tue, 21 Oct 2014 22:27:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        khilman@kernel.org
Message-ID: <20141021212733.GC2344@sirena.org.uk>
References: <1413863014-1791-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <1413863014-1791-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/atmel: improve the system suspend/resume functions
 implementation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2014 at 11:43:34AM +0800, Wenyou Yang wrote:
> To make it cleaner, the system suspend/resume directly call
> the runtime suspend/resume functions
> and remove the wapper of CONFIG_PM_RUNTIME, CONFIG_PM_SLEEP.

Applied, thanks.

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURs/EAAoJECTWi3JdVIfQbv0H/RgSk4I4ouelcB4hJpU7uubO
JOSW3UZAb+ZI9SMdLprqe/Gr7Fxf/DDuVeExrWZ2nFhl+Ha4BWTqg96OeCD0rLjD
DM7PwYPNZte7HXTFfAPV4uqPg7UDPKuPPOSrGRBjt6odQnBm6S3A1xhzhuB2PrsA
Jbx7mU31dxKgrAqsLK0vtSMaYGclUCW1fISW939cB/J/frdS4PSvS08Y3wIDfWMK
zNaRvbqZ1eRI0mCYpKEwJc7CZLG/q6lNcq3T1+PqqfaKLnGa6whxBRz8TyKx/ENS
FNDS90X6TsmPvad1mIHZqd7JUgVdhti811zczVjnj7TatejS8BaLEpyRqs8M9Oo=
=qtFQ
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
