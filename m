Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbbA2Dqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:46:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38392 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbbA2BZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:27 -0500
Date: Wed, 28 Jan 2015 19:43:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128194311.GL21293@sirena.org.uk>
References: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="w4kmnulvTLkiEiiC"
Content-Disposition: inline
In-Reply-To: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 00/15] spi/xilinx: Speed-up
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w4kmnulvTLkiEiiC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 01:23:39PM +0100, Ricardo Ribalda Delgado wrote:
> This set of patches has been developed after using the core to access a spi
> nor flash. The initial performance was not as desired. The following changes
> have been done.

Applied everything except the MAX_CS change, thanks - that's fine, just
needs the define namespacing.

--w4kmnulvTLkiEiiC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTvOAAoJECTWi3JdVIfQAeIH/jY5M7AACxsPPc5/154+/igf
xB1YBGfVxVVq+wT3TTvTZwXKvfSjfWufV6FIdu0V/IDhLjn7u8+sPzJxdKRvs53+
haPmIzd9fh3EMyi9wo8IRkVoaaUAbF3jQ7565vI39e1lJQYMJ/Og9x+kNPqT5qGf
SYjrzHKivM0pi+lulOHkSSgQ0vHxPDFlvJqPZSnFgIyQJtFTqCt01+xbZUBk0+mw
HwxOyLoBkSktZLl8WUrWccm5zyzHvma0js/oTLpC0BtY8uwYBQ6u1D758Bzkcm/a
AXOX4ILu7QRhzOQiKnCROM++72gl+1mbJjjAGk2WyOaV+PJBz3vT7ZClUFf3mbo=
=ZkCl
-----END PGP SIGNATURE-----

--w4kmnulvTLkiEiiC--
