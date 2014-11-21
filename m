Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKUSVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:21:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34029 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaKUSVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:21:34 -0500
Date: Fri, 21 Nov 2014 18:19:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141121181949.GG3815@sirena.org.uk>
References: <1416481668-22321-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UrS3HlPIImnL8SYr"
Content-Disposition: inline
In-Reply-To: <1416481668-22321-1-git-send-email-b50113@freescale.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v3] ASoC: wm8960: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UrS3HlPIImnL8SYr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 20, 2014 at 07:07:48PM +0800, Zidan Wang wrote:
> Document the device tree binding for the WM8960 codec, and modify the
> driver to extract the platform data from device tree, if present.

Applied, thanks.

--UrS3HlPIImnL8SYr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb4JFAAoJECTWi3JdVIfQAfcH/RetDQIp18AS41nDiKafV5ns
EPs2pVcQAHky5dpln5vO2ioj+LAzWSj2aqkVeaY8lJ0mRhnx6eVl84c232+Hx4R7
5i+rHyb+WBciiCooTgDwKHrjzajZcLN+beP1/o+e1QYBGz6Z9jqRwoYkgyX3MrmQ
OzfxStaSz/ePeBqpt2bfzFBLdSTVxri4Vw4S8086AeYYDmKMDnceSN1xGIg7YaF3
mHZ/oWvTlGfP++XWghP1rqLca+bzIrrTga6PxOi0anKUsAhaZqaW5ikLDk4vR7++
W0ejbejuTOIvxYyBBHhQ2eQbFpiCb/plxt4Vxppd28CQBNk9mc6oamkNWzMDzJA=
=LJ44
-----END PGP SIGNATURE-----

--UrS3HlPIImnL8SYr--
