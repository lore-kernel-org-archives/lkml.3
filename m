Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbaLORmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:42:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60688 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaLORmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:42:10 -0500
Date: Mon, 15 Dec 2014 17:41:42 +0000
From: Mark Brown <broonie@kernel.org>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-driver@qlogic.com'" <linux-driver@qlogic.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>
Message-ID: <20141215174142.GK11764@sirena.org.uk>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB01A@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103EDAF89E148@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="56hrQfoz910L17cR"
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103EDAF89E148@CNBJMBX05.corpusers.net>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap:change spinlock_flags into the union
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--56hrQfoz910L17cR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 04:05:50PM +0800, Wang, Yalin wrote:
> This patch move struct regmap.spinlock_flags into the union of
> spinlock, so that we can shrink struct regmap size.

Applied, thanks.  Please always remember to CC your posts to the
relevant mailing lists - in the case of regmap that's linux-kernel.

--56hrQfoz910L17cR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjx1VAAoJECTWi3JdVIfQvWEH/0WV2+snUP/Rl8iyK6ig8cOz
XR/MJLJMLb6WVH4FCbITQwsL+kchn0H44Mzdsn0dVvLRM7qNvbB4EmQvK7MalAmW
W8LlwD0F/9j6Wfs9UtHIGwNjI4dtHlYkutX6Hz01Xvxt3MKyCw0LTH+eA8kAy/CZ
g7cGNRQG9c3m5na7tJVOkDsjd3oolT/6lT2QjMmazpMRZ8xewcitFLafPTFmzZWn
O3iPTqpS5yJoln/8E5Al3bDG1hAM3Y9ZxnZSmYhiP3CnmD0aeD4vUvgpNIyFtBG7
UPvDnLqBv3ntaZB8pYXOZrDxdo/VkcOG+aiDTijW3b0nET/sKJFH1drhSusPeC4=
=kREj
-----END PGP SIGNATURE-----

--56hrQfoz910L17cR--
