Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaIYNEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:04:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40320 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaIYNE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:04:29 -0400
Date: Thu, 25 Sep 2014 14:04:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        linux-spi@vger.kernel.org
Message-ID: <20140925130419.GN27755@sirena.org.uk>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-25-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qi3SIpffvxS/TM8d"
Content-Disposition: inline
In-Reply-To: <1411575342-31048-25-git-send-email-vinod.koul@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.7
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 24/27] spi: core: use
 pm_runtime_last_busy_and_autosuspend helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qi3SIpffvxS/TM8d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 09:45:14PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code

Acked-by: Mark Brown <broonie@kernel.org>

--qi3SIpffvxS/TM8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJBLSAAoJECTWi3JdVIfQT8cH/0x56LoEjkklCIPaqF8gCwVv
fwQPlYLkWAWgP/lVqr7aB2QkBX5Fh0O8VGGnjSePcWoAW5ufS1AXwqpcvmKLNBs1
WKxD/SDXDN3+eKIgwbIe/cNvhbAIOW6EZTeBpybBwgYhFdh9Kn4d5TjS7WaOrIZY
ugz4rFBXBT3xrw+PM6x6biGpWsLmbCsqXV0P9gsslBrml8CDcYj2zjOSZlcacz+h
wZugtOM/g68jSfVmeOmcCcewDwENDpOP9vaustW6H+iqZq5lGnauVmh6HEG29kk/
qxj1Rcs/dhP/JHVj+IRfeBUB7q/rzMgW/04u7ahn/00OqMb0Fpqf9Z6o9gS86mA=
=GJ5j
-----END PGP SIGNATURE-----

--qi3SIpffvxS/TM8d--
