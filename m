Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaLCS1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:27:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47340 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLCS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:27:16 -0500
Date: Wed, 3 Dec 2014 18:26:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Message-ID: <20141203182659.GG7712@sirena.org.uk>
References: <547F3C96.9070509@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WUTMTnGprlFONK8E"
Content-Disposition: inline
In-Reply-To: <547F3C96.9070509@arm.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] ASoC: dwc: Allocate resources with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WUTMTnGprlFONK8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 04:38:46PM +0000, Andrew Jackson wrote:
> Prepare for the introduction of device-tree support by re-ordering some
> of the allocations and using devm_iomap_resource to simplify IO mapping.

Applied, thanks.

--WUTMTnGprlFONK8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf1XzAAoJECTWi3JdVIfQQskH/Rw0xIo5VQ4nbTzjoaQ9sn2I
uDjsnuzaq3mZOgOSkKCyoGnGzA9FlnsCWmxvdt9ReKKuehIBP33UnIlEQgDRdP27
WWGJdxbWXqplrRupo7yVGLhgDPCXRreIzN4oaBBbEpeeq4mMCVRWhHBMaLmUY4P4
UOmMM0m7mlDLuIliVhV19puCUPR07Ok8UdiOLGnH8wz2ND/UCRoqMUK6hlTGwJBg
4pdkYB5k/tQsbLzBbVYVzqDZZneHBRa1P+wtSBxEhXyFPbBQcdB2No1nQQNSa3xd
WkrEivQesqahIlXHJl14dIzZET8TLrZWJj+lMjlIA52T/7JWYmFE/RQMlrSw2m0=
=Ky9s
-----END PGP SIGNATURE-----

--WUTMTnGprlFONK8E--
