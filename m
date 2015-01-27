Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbbA0AF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:05:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35287 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbbA0AFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:05:55 -0500
Date: Tue, 27 Jan 2015 00:05:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127000546.GL21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-7-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qmq+yACkV15HOutv"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-7-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/18] spi/xilinx: Code cleanup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qmq+yACkV15HOutv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 05:08:38PM +0100, Ricardo Ribalda Delgado wrote:
> Trivial fix

But it's best to say what it is in the changelog.

--qmq+yACkV15HOutv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxtZaAAoJECTWi3JdVIfQoboH/1rRpfSaZ6LT7cI/Gt+IKaIr
aZHKLzz1utwn9MwQL4RVD7DpLoVkIIKstGLgaayi6Z0XvY9SsZ6QTYXQCs1Kpm77
ui18NLhgbggIvPTiMA7+YUQQqk9HKYsTyVY4VtkHIbvQ1v90id8BIfTtl/F6akWT
bw6D8A05KVp0der5qNlXiKjAbodNN/3YHz7y8bAapqhJLrb6SgkHZRfA/SLgKLSo
mJCOiV0b77Q1XHwmrPqpnoIassf4qN902OQvMadt8Pj2GYTj1Qtq6QRObYuaQc6c
Q/va/DPgWuVxkOw9qx8eCkCe7UDm2jAH8apD7sR0tJhSSegJOHLzFOLTiihr6Rw=
=sEW7
-----END PGP SIGNATURE-----

--qmq+yACkV15HOutv--
