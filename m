Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaEZNbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:31:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43100 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaEZNbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:31:42 -0400
Date: Mon, 26 May 2014 14:31:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wenkai Du <wenkai.du@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Engelmayer <cengelma@gmx.at>, alsa-devel@alsa-project.org
Message-ID: <20140526133114.GA22111@sirena.org.uk>
References: <20140522184355.GA8301@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dhwE6X0TwXvg345s"
Content-Disposition: inline
In-Reply-To: <20140522184355.GA8301@www.outflux.net>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.144
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: avoid format string leak to thread name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dhwE6X0TwXvg345s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 11:43:55AM -0700, Kees Cook wrote:
> This makes sure a format string can never get processed into the worker
> thread name from the device name.

Applied, thanks.

--dhwE6X0TwXvg345s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg0IfAAoJELSic+t+oim9Z3MP/jpW8Yw9AwV/GIPYJ/7t/wPG
4cZC1mBU4b3QSjm81qGCiACnHW9hFOM6Aht5m5s56CEEyb6FZZegttOBMChcTF7n
f7AoyIaPc5BFqtpWlwQab8DU2WfMXJwc98iD3Rtxvdt79OdcB8rOKpI3CaWQzRZ1
ssPYkyyvR5+rcVgKVNkHUT1QH3BTLAYUHsXRSub45JpglmC9MU/dZXX6x2z8tZp8
rxQRUoIZIR1+rtbjmvdVPLxZ+CcjmUsRMD8Xk5aP+HocsUQd81LhrkGHzdVSEMpR
QwX+wxGCC5ou7IWI/hWtvY+XJ6gsYV+ksaH12UWntnHnX3SWSfUgEAaRmXtSi6kP
fkqzApKbY9rmaEfDVEFriJcMIYKIa8I2Bs9eQTknPRDC+7avVEZQG5gzztY5EGpC
mRUjgpHZ2XBhRGR8NXk/6LMuGWkueqFJssZ5QfR72cgsoxfK4Q25dYWg5pdcRwL+
rWvpa/J3Zbj11U3OICHgZ9IU/c9uQWkM/hONBnaBWBDBi+1hxJD4lDBG3TZ0SN1M
FGtohDW1uL2bEINKkZn3s9wNye2N/+Y8/qw29+RhSUaymdmoUzP6EZEIgBJU5C2C
kM3037EjyUOpFoV0Rg/+wnrNqoDmpt2UuIS1igpwHnKyHkCPcO1jBzbOk8FsLmmz
Cd3f8G2pUPZX8/f7Ceum
=noHH
-----END PGP SIGNATURE-----

--dhwE6X0TwXvg345s--
