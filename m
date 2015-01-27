Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbbA0R0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:26:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36510 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbbA0R0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:26:07 -0500
Date: Tue, 27 Jan 2015 17:25:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127172550.GA21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-4-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CeJGzupbOM8Uylfo"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-4-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/18] spi/xilinx: Simplify data read from the Rx FIFO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CeJGzupbOM8Uylfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 05:08:35PM +0100, Ricardo Ribalda Delgado wrote:
> The number of words in the read buffer will be exactly the same as the
> number of words written on write buffer, once the transaction has
> finished.

Applied, thanks.

--CeJGzupbOM8Uylfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx8odAAoJECTWi3JdVIfQ7l8H/13KhfkONQbz5VjeawqGz9YI
AWGJ0pfEGajcrZyfyBOtqUkUmAoUZ2cfigP5A8aMkMxvkS7UBoSWBwzyWgSebObF
v7h5A1gAvDtukMKs/0zue2c1gJMqjsY30H8Wtipx2AUMMDc+IqZ0pjWUme5UFJfJ
ZG0HHuCXXg9mCh5DSBKS3N+MtU4qpASnhF/Uly6w3YjiHFAg2Jn4fCLGPM1eMBPW
dHFC61PejoZQWcZBJusltrlEh6gswxukfT08qwExqWQ3o6jcm9Rqi9IrhswwS6Yy
wWKfEU5N2W3n7kredJ9XRWHvJ1PILCN+2FXfVsksgGxWSAV7+VYwFP0p6SpT4YI=
=jyaf
-----END PGP SIGNATURE-----

--CeJGzupbOM8Uylfo--
