Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbaGNSWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:22:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37323 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaGNSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:22:05 -0400
Date: Mon, 14 Jul 2014 19:21:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140714182152.GU6800@sirena.org.uk>
References: <1405094477-14192-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULJ2Z7kCM1hyNsWd"
Content-Disposition: inline
In-Reply-To: <1405094477-14192-1-git-send-email-geert+renesas@glider.be>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] spi: rspi: Handle dmaengine_prep_slave_sg()
 failures gracefully
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ULJ2Z7kCM1hyNsWd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 06:01:16PM +0200, Geert Uytterhoeven wrote:

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
> v2:
>   - Add Acked-by

Please don't ever resend things to add Acked-by - this just adds to
noise and mail volume.

--ULJ2Z7kCM1hyNsWd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxB+9AAoJELSic+t+oim9DWcP/iof3Dva3BaAM1RrRrR2eWsA
UpUQOzYi8xUXoPT/w3z+JzEnSTiAVi0942sgWpPOZ5YOtY2D61NECI1BO+YO2MHe
r2dXEoT57TtLLBwHOwncsyXNwGCYgIcUPeQG3m3ibcIkRpwUfJWDFxZkZG2VBPTD
I8usfje3Iops3RGm2MQWQ5I4bj/RhYLJjmZ4KXBeRU/XMuiXWjJ6ldq2c561GvZd
2YtN4le0DI5pEu8k9pL9pb3FZKvQCLzxeHW/niSPdwW1v3mClHClSbNZboyCr9dS
Mxn9I/1R5a3Fr+MoUmVVBkmTXc76T1i6irzr9OWtOCh4txfQWnljosKfZ7/jS54s
1kLUBklkO2PuV/EaTCqj/hctebkDCKHBTK+iScmLqS7RTfJQ6t6BLE1xO+sldRSQ
BcpU5TYjDV3YLDyBRW9Q7u0lrfmqYbfTzNbTwPZ5die+Xj9ssrIDbqd/DYcyXynn
CzMvP0sZ7FmZs+O2PdFzN9ooTS+wLj/nMKk1aXxZPAzNaepjqNvaEJwcbEcbNNmc
5glXVN9WdMuvItGRfMZhiNVcwIhWekjznYlAyEeGfBr9c5xz8IJ3l+OvxF+EDMWM
/oV9L0qMFp03dA76NP49P3Cj1K7/6+VHDPZGt2TmRenGYOQbNdrFPGjj2UpD/QZX
teVHJTa1scrWYRGG+gxj
=PFeY
-----END PGP SIGNATURE-----

--ULJ2Z7kCM1hyNsWd--
