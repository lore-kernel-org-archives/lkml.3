Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaIXQ7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:59:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38484 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaIXQ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:59:02 -0400
Date: Wed, 24 Sep 2014 17:58:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        linux-spi@vger.kernel.org
Message-ID: <20140924165855.GK16977@sirena.org.uk>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-22-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mGCtrYeZ202LI9ZG"
Content-Disposition: inline
In-Reply-To: <1411575342-31048-22-git-send-email-vinod.koul@intel.com>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 21/27] spi: omap2-mcspi: use
 pm_runtime_last_busy_and_autosuspend helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mGCtrYeZ202LI9ZG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 09:45:11PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code

You haven't CCed me on anything earlier in the series so I've no idea
what's going on here but it looks like there is probably some
dependency?

--mGCtrYeZ202LI9ZG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIvhOAAoJECTWi3JdVIfQDaMH/130+TFZCEsIoVdMG2FNoNG5
8jdVavVu41kYH30h3NbB6SJ5/84NL2IjUkzOTxbLgOPBsaYNzpDrPPE7QDX8IkKW
oHrTtzNVv0NamzLyYWZ+fgwS+TaB+buL8bMMhe3xe9D71iZr0rEYoWuA+rNyZ7gv
y9NunQDC3jW9HFfpB+QTnd0IVLLhdu8W/RK0pXLWuo+Vb+hCaTw/pt1SsSD8ISEQ
Jwj4I0d3d7tFIFYnY3VGZlFdcn/gkcBXpMf3WiSBEA0Ksq/8OR2/DkdZg9Bhc/6k
3cf5kjmgI7lh3nJamj/Y7nJjOZT6Y9Pxy/5i1yMWeDBw85LuVLavtOifG/Rd2t8=
=+L+i
-----END PGP SIGNATURE-----

--mGCtrYeZ202LI9ZG--
