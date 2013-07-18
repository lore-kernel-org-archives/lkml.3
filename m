Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab3GRPWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:22:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39909 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3GRPWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:22:40 -0400
Date: Thu, 18 Jul 2013 16:22:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        balbi@ti.com, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718152214.GR22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-2-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gb6VZqxBV+KJ1lA0"
Content-Disposition: inline
In-Reply-To: <1374141687-10790-2-git-send-email-sourav.poddar@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC/PATCHv2 1/3] driver: spi: Modify core to compute the
 message length
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gb6VZqxBV+KJ1lA0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 03:31:25PM +0530, Sourav Poddar wrote:
> Make spi core calculate the message length while
> populating the other transfer parameters.

Applied, thanks.

--gb6VZqxBV+KJ1lA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6AgjAAoJELSic+t+oim9v4QP/0bmwo+Khybpw5bjzUVo3RIp
/ZGRBntxX1krc2JW974r67fHrlbbV1tW/x8EN6xI4NK6HFOOlTI4kK9RtW0BLTD9
QTy2OKe8AVh7Db6OXU2WGD1lQOFHbVAzoPDGZmBnfyhiWNVHlLBm9ZyHz98CpnDh
9TFJnt89AhJ8vdIavRTARsojvolG7OmghnQM5vqgK6H3eZmwc6SGvckETpH+iqHK
BhpZUim54YYe0+PZlYJ8vhYbOp5tG1nBFg7QNss8XgPaGKiQunbh7/cGRl2FuQAd
4Ny8IeU6SWjLyLXIDGLB8w8qJjpTHAKWDOnlXmEUMmquAW2qZWkU8qvNUPXCBkDV
s6ggkzD4EUqABqHoqEqBOSDBplmS3+rFnSrX0Mb1Iom8LB4byBbpV4LH2zaA8yOr
1L0kCl3DLDaPwkieyw4m6VHJGvel6t9OGFSP6ols5ctiAFYngH1clXO70ryWulZ0
MC5mYBkxxTJ912FjGNIThJk9lGAmZ2WJ6obU1Unek/rB42GUSgjdmW32wlmfY5t6
9kw96SgHw9nRcOYeDj1BqvbLmHmJEQXFaApYKXfcr2xA2sudeCGi+DvHib0COl6y
6dI8Rd5CG3RTeH0hDFpRYdVb3PtItQZo7/jfBUmCtOQjws5FGLNA8/gpyD24bCDr
5WA5o1S6YGxZjR+PKH2g
=DCcK
-----END PGP SIGNATURE-----

--gb6VZqxBV+KJ1lA0--
