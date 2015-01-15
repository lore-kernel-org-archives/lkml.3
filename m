Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbbAOPzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:55:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34066 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbAOPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:55:04 -0500
Date: Thu, 15 Jan 2015 15:54:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: alsa-devel@alsa-project.org, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Message-ID: <20150115155447.GA3043@sirena.org.uk>
References: <1421225249-19762-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ofekNuVaYCKmvJ0U"
Content-Disposition: inline
In-Reply-To: <1421225249-19762-1-git-send-email-qais.yousef@imgtec.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] ALSA: ASoC: soc-compress.c: fix NULL dereference
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ofekNuVaYCKmvJ0U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 14, 2015 at 08:47:29AM +0000, Qais Yousef wrote:
> In soc_new_compress() when rtd->dai_link->dynamic is set, we create the pcm
> substreams with this call:

Applied, thanks.

--ofekNuVaYCKmvJ0U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt+LHAAoJECTWi3JdVIfQCuwH/2pzlpBqB/Sq05DrifoytVe8
0krBg9wk0CCFXPmNC5Vz7wEmkF8O3GTNKYNNCw0FNvZ4X6oLcEHTKxtLEcR0MFDG
oe4t0isIUVn98RFijjAJSTFOZVrHFDnSKkIYCLN4TQdnStQxKlIf+INALSmtpWAW
pq72NLVGCluP3C3QBRRthiDHw+O07urXVAPuL1OYHWEQfiee/WSesQisQSLvqhdj
IWRcmtaFOAw2p5JSJQt1xz2Pt9NZF0rXvY3iV0Fajl7d0KTTIoc3vysVwakEcFId
4DwOMgh6nM1ycOymbLBUOaNJPYE2nYh5HrZ96CzngPOxBG8QXov0k0xr87Hm82k=
=qJXn
-----END PGP SIGNATURE-----

--ofekNuVaYCKmvJ0U--
