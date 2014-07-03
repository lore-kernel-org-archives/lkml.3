Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaGCMCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:02:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44881 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaGCMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:02:31 -0400
Date: Thu, 3 Jul 2014 13:01:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, lars@metafoo.de,
        tiwai@suse.de, Liam Girdwood <lgirdwood@gmail.com>, joelf@ti.com,
        nsekhar@ti.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org
Message-ID: <20140703120153.GZ410@sirena.org.uk>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
 <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m3EZO/+NOdcYnaJL"
Content-Disposition: inline
In-Reply-To: <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] ASoC: generic-dmaengine-pcm: Prepare formats mask
 for valid physical sample sizes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m3EZO/+NOdcYnaJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 07:51:54AM +0300, Peter Ujfalusi wrote:
> Based on the dma_slave_caps's addr_widths queried from the dma driver
> prepare the hw.formats mask to include only formats which is supported by
> the DMA engine.
> In case the dma driver does not implement the slave_caps the default
> assumption is that it supports 1, 2 and 4 bytes widths.

Acked-by: Mark Brown <broonie@linaro.org>

--m3EZO/+NOdcYnaJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtUYuAAoJELSic+t+oim9Fu8P/jp+EMq+OewwFnnLp+8qhj8q
poXsS6xmSgrhlniBGFzYtXHCxKB017i2A4yuJkG/Wm1eOhXxrgiJmO652SdzVGlP
N4EQcjyH8NxfqKOBAfxn7cwcb0xjb+Z1OITuse2wDVRRbYusLY8cJFSOZz2Fn3tJ
lrfyg2q7Z08kuvKqkJxVLfORFXoYu4CGVBa05mhnx5CnqjhS5xCvqvLm0T3e9EWs
LwfQDJWw/pijn1WnTp1uICsKVlPGE1fLkO7Icd7a5gIoyA6YElg+bmljQKuogxem
WoyXaoxq5grf8Sq1YY11Bw0BkejRhXUU4oMYV9Nyd6dr74LTvKBLhKlfC54wsbbJ
tDhdwMRyL1Z2ltxtL6sRy3d4fCyf1uzECOB9zBVU7iqz0I+w8K79hQyNhM9R4Eep
SfwvY9iOCmMUYOk7/Yx3KBP8jIJelwdEfBCnS5CB+Qqtl0tR8ioRIVJk1LmNKUVw
KPal1ipKs7QKlDb3/2MX9O3ae77hEKqbglnzIUJNXvMMIqDSVaFve2ajkm1SC3yh
3kWvq/pcwe3yZUWfX0fAln3JMrsk5MCuCr1D38X5sajlMxFU14whu8aCHrDTS/EK
XOvg+eNZEAk08AczvtiMkzuCoREXDRYVid59yKY2eDRcunf/rYAt89K7KyZt1tvx
NoOyToPA/eO/qhjMOcZP
=9New
-----END PGP SIGNATURE-----

--m3EZO/+NOdcYnaJL--
