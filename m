Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaDOLN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:13:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33753 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOLNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:13:25 -0400
Date: Tue, 15 Apr 2014 12:13:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140415111301.GP12304@sirena.org.uk>
References: <20140413195636.32f31cb2@spike>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tZCmRiovzb4sxAVa"
Content-Disposition: inline
In-Reply-To: <20140413195636.32f31cb2@spike>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: Fix incorrect sizeof() in
 sst_hsw_stream_get_volume()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tZCmRiovzb4sxAVa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 13, 2014 at 07:56:36PM +0200, Christian Engelmayer wrote:
> Fix an incorrect sizeof() usage in sst_hsw_stream_get_volume(). sst_dsp_read()
> is called to read into a variable of type u32, but is passed sizeof(u32 *) for
> argument 'size_t bytes'. Detected by Coverity: CID 1195260.

Applied, thanks.

--tZCmRiovzb4sxAVa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTRQ6AAoJELSic+t+oim9g2wP/0DfhBhzFBpVF4/cN4OnVuVb
6cxraL3pVExHNsFNWDdu7zH7qkrYfE0HiPwI5nX6ibzHWmiE4/pg6VwcnfFwt/P4
0/gUwZsl4QhP2R+7gVnRK7K0ZGNhSfA/zuAbjwzgvY8w0zQEtWsHJed+cMhfX+lQ
AG5hHEO7c7D/ScgNFljR1Yx67sOyK3we+nc4/u5bl0g/tXINJr2W6ni71h2Pbjks
HfNchHdJQaB7g/WLbY//jQtavnRHmEnavLrau02s3gxf7rI/lMCxhmOlcebcGx75
3xF+ZrQqYQk/ZuGwyBy8a2fOmm06MSnB9MMuvW5MmZf3BRiol+Ju7S9V/m/xTl6S
M55gkraxEeHWH6L0lK9FXYm9ZXs2iSsItSm1CTlT41t03h1MojGoLreuXiu8gyU7
jxZnTO872IGlkn//KvjA1tEf6KcRYwcZigi/vVE9AfPgOTtEXN9n0eeNt6/vX9ZW
YlnrLELZpzUDrt6bOH5Ltt1RUsI2Zbx5YUsQ4SzK/lBXFrdiBJscZ8oNHJ9ayqTI
4VEpp7oV/Pfd5HRDzYH+8+zLnzMnRCSHUubz6BEKnHlQTApjlxhOIsIjl4SSMf2d
L44C2pS9eXVS7+RkqJkpl9Ncc+J3FHSalaOSLiCc1BYbWg9eF2PRLNQQ6d/76xnK
1xnsTn6TULiH/8wagL35
=GUtB
-----END PGP SIGNATURE-----

--tZCmRiovzb4sxAVa--
