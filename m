Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaDCJxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:53:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50609 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaDCJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:53:50 -0400
Date: Thu, 3 Apr 2014 10:53:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arun Shamanna Lakshmi <aruns@nvidia.com>, lars@metafoo.de,
        lgirdwood@gmail.com, swarren@wwwdotorg.org, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Songhee Baek <sbaek@nvidia.com>
Message-ID: <20140403095330.GS14763@sirena.org.uk>
References: <1396494710-20944-1-git-send-email-aruns@nvidia.com>
 <s5h4n2asq1o.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LmUdgXdNLPkN/XLh"
Content-Disposition: inline
In-Reply-To: <s5h4n2asq1o.wl%tiwai@suse.de>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LmUdgXdNLPkN/XLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 11:47:15AM +0200, Takashi Iwai wrote:

> I'm a bit late in the game, but I feel a bit uneasy through looking
> at the whole changes.  My primary question is, whether do we really
> need to share the same struct soc_enum for the onehot type?  What
> makes hard to use a struct soc_enum_onehot for them?  You need
> different individual get/put for each type.  We may still need to
> change soc_dapm_update stuff, but it's different from sharing
> soc_enum.

Indeed, I had thought this was where the discussion was heading - not
looked at this version of the patch yet.

--LmUdgXdNLPkN/XLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPS+XAAoJELSic+t+oim9lHwP/2uZ4nlylfyzTPNCpWjcQXeL
WprHEKyxvF2Sa7mQHQc/MlyQk1yIT+KxkyZWg8GBbtIYgNzYcPGAq4USojFp8xRu
mlBYbm99+ZcD29z6+1Dggfutym47CP5q7Y/dF2pwYOKf3TCXyCU+F1mXbEHibEIV
hh6ohVewYuMlz3J1jGsMTkPkBcDKdSIPC+UP+mS3YQCb+SMhgON2huP+9uN0L2dD
cYPN17nd4YchFew5FZb27CX3TZKS0BhM0uOuPfNqEp5w5tEgf9vCkbq57XvENWq7
yDRzHjEX0VG6v+KhJcN7mImTrvawC53ac2OnCFcw+rX4UTYAQT3Oah1KxiFAgTu9
AQ0cSgI/TOkKuYWyGeRhdzwUALzn2YrHD1tW43uKAfUNKb3rKjrgXGgrgzQQukTi
0L6Qwz6FyJe37mQvBiYVe/Vch+W2Q3DQkQ68P75wTms5ETrLvm83fBfpItFMB5DW
5HDSNWLLK/1aEd5DRR9vyyJNjwPGtyF4CUkxvnqDi0D6+pPNiRqvvdFPK+1HzjuO
VTH09kGBqyzWphdgi087Y4PwWqnIHPQheaPB2mYuww6gev0/64G0ifYEnSU2wFcf
XWiZmaHRTkpErVZ5hEuJ82tfYKW/rQEDZ41pKylN7xiwKMCRkLYbD2sqZS7QSJZL
l/k0omz1xQu+sTbm/Q/0
=7/vO
-----END PGP SIGNATURE-----

--LmUdgXdNLPkN/XLh--
