Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3EHKvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:51:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45653 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3EHKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:51:40 -0400
Date: Wed, 8 May 2013 11:51:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508105124.GA7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jsn5+Lu/ZvzbAGtZ"
Content-Disposition: inline
In-Reply-To: <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Jsn5+Lu/ZvzbAGtZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 09:14:18AM +0200, Fabio Baltieri wrote:
> Drop pinctrl default/sleep state switching code, as it was breaking the
> capture interface by putting the I2S pins in hi-z mode regardless of its
> usage status, and not giving any real benefit.
>=20
> Pinctrl default mode configuration is already managed automatically by a
> specific pinctrl hog.

I tend to agree with Lee that this looks like a bad approach - there's a
whole bunch of other code in there which I'd guess is probably equally
broken but only the pinctrl code is being removed.  Why not just fix it
(or better yet simplify all this stuff)?

--Jsn5+Lu/ZvzbAGtZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRii4oAAoJELSic+t+oim9KmgP/3UuESUutQ3yJnaQpS4u76AG
qbcgcGVV/yCMeqvo5p115+BTy5hcFOYkIL9Js0mRaKX6uXcwYasG/L18AhPY66hF
xaYTow7OxQjF8xHpDyH3y36DNKsJHIBL2U9aznXVltk9hIxDFW0lPJpX1bZ71rvS
/BvsVW/O9E0sE5NCraplLBnvGA8x7EXC0V6h2nSkT/Qqj+Gl9ceIOPUXkC0H2b7I
qPDS34FysNl7JlJj5txK4RDHJe7NIYB+A79syJsOjbGz1mw70Rl28USvixHgU16/
DTLVSAKA8j599ONHDa1C/a9gaIubKomY2WjY7UFz/PpQ5vIjWmEwDKjnG5EjtEz/
uztGZlXi5CONCccX8+HzjF9pMsEcd+Mqou8f+7APNZC7leTgW9v5AouxNEZqTV6r
nGPa9cvBtgHjOjEGgwkS0i6PmCDyT8pW5QiQtzwsW95xXqRhkwpolR+BvPN1i8Vw
eYF9wj0Yqd7K/VDxhnGalRlS4ETr/drsY+d0CvtpeZQ74zENTVrxTOfu2JIwokpW
RdR3i97Dr1vl48aTGmktkjkqoL+hSETu53gndDR3RGELwerCDfjgEUrvFQhQUejT
BrpLVN8HFYuwrNsgDPeiccQXVl8Y4NGZ0RycrckhXGIkGwJoCcQoWySh7NkY1s6Y
vzu+kaAqOycnRkn4oL91
=dyGU
-----END PGP SIGNATURE-----

--Jsn5+Lu/ZvzbAGtZ--
