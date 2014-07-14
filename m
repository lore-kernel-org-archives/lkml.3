Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbaGNS7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:59:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37418 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbaGNS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:59:22 -0400
Date: Mon, 14 Jul 2014 19:59:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140714185905.GF6800@sirena.org.uk>
References: <1405094802-14401-1-git-send-email-geert+renesas@glider.be>
 <1405094802-14401-2-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f6nK9RR+X1IX2pXa"
Content-Disposition: inline
In-Reply-To: <1405094802-14401-2-git-send-email-geert+renesas@glider.be>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: sh-msiof: Fix leaking of unused DMA descriptors
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f6nK9RR+X1IX2pXa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 06:06:42PM +0200, Geert Uytterhoeven wrote:
> If dmaengine_prep_slave_sg() or dmaengine_submit() fail, we may leak
> unused DMA descriptors.

Same here, this doesn't apply either.

--f6nK9RR+X1IX2pXa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxCh1AAoJELSic+t+oim9pzUP/ivBi4h7u2tDtwgePJRXxXCd
WhYf7fViJXEWoy23nO8AbXOMy8y+TW1R+tSk3UMN+uBhuv4Rscul68HnEUXr36PN
Qyx7m6PEY0tphQPdLdxf7oqAbJJgeIMvp+tQP4AkoTAVlRWzztO8Qtql29mowHP7
YvakqGTcIZC7N24q5GKvNKpVeuuS2gBXDE9v1a/LDaY6bE6GJp32cwo5sYd/cd3W
CBmLzD+oyeA/fS5JiI0JbQb5nl+Za+Y62niPZH2YbBdsJCe2rmURyePII++o3r0w
dSbUx2uPPVwCm4yqnhWv3ML+zcVMR3Dd19uqlGh9WS0JSLRS4T1T0FzdLpl4F4jJ
2DVKqsgcr9tT1ocG2zOVPqWw1ilACWET4ZRFhZNeLEjekKaT/BjpCZYmiXYfvi90
l38Z6GGdbEqVcGGmwWmjLrk5wmoEvRf5K8f+6++EpKok6RW7GRG4gdHuud2gIV3q
Va+5WAFN+7YqRc4OeHxUPF+c94qJ7ei6yYWmBvxo008/9ZtiblCdYfJEPo0sBBDW
eWyrVimJcFOZDhKfVDFvNH/7A2eoghrlGriKKilMbwj6KtxLHnrPsKaTQTbtHTQN
GONM10c9qqKh2undyxSCFWe/+9sJqYz3lJlL/VRE9Pf2iSvNNeOoWTNitRn76svZ
QgjVmffGcd7VAtnRVJHW
=a9Uk
-----END PGP SIGNATURE-----

--f6nK9RR+X1IX2pXa--
