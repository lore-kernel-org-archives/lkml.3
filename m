Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaBDRqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:46:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35353 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaBDRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:46:42 -0500
Date: Tue, 4 Feb 2014 17:46:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140204174627.GK22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <ae68394f080f0ea5acaf3377cb1d18f29e42c646.1391274628.git.moinejf@free.fr>
 <20140204133014.GA22609@sirena.org.uk>
 <52F0ECF2.9070102@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c4ATLI8HJzklxeaH"
Content-Disposition: inline
In-Reply-To: <52F0ECF2.9070102@metafoo.de>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3 2/5] ASoC: tda998x: add a codec driver
 for the TDA998x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c4ATLI8HJzklxeaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 02:36:50PM +0100, Lars-Peter Clausen wrote:
> On 02/04/2014 02:30 PM, Mark Brown wrote:

> >>+static const struct snd_soc_dapm_route tda_routes[] = {
> >>+	{ "hdmi-out", NULL, "HDMI I2S Playback" },
> >>+	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
> >>+};

> >S/PDIF.

> Won't this cause issues with the debugfs widget entries? It's
> fixable by escaping it (replace it by a dash or something) in the
> debugfs widget filename, but I don't think we do this right now.

Oh, bother, so it will.

--c4ATLI8HJzklxeaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8SdwAAoJELSic+t+oim9h5MP/2ovfQhynAZqb/azeBIcx/Hc
zA8Zi7gcGynDMHAT6aUuJmmq6QVR9HFcGXlY7qWWuo/NubyZAUtbXjxTsxYQsUqs
YwKW9SnEnia2XoYbzK+dH2+58jht41LHw1Bjt1Uhb3XUL+0hDdk6RQQGKEhi61wn
hXTZJ+UF+s/7609uRvZvICVmxesp6Cy0yEvRJYzf3H10JsIce3AJYsNNR/MhhoUG
n50gOtwqQ8mKWLGoqrJf/bz+RfZ6G9UrjNiXn3aY/NzjnmsJECqTHBColw3zP5d/
zCw35oQYPeu6Q0HQa5eLB200aGm0vdA/GZSTEt6e7wDerAuD++YlrxuNOdHG95km
datVUmB3lEHnnDdfdCY+bEEvi327x/5tYpcU0jZELliVH7vHxP8vDIW8OYLQOayl
puRk/jTZtOFGoOe/D8OcV3vgvD2ChQQONNd+3zi2LnF3uR6KZEbPHsw2d0NBjCEz
dHFCaGUQR/UaY+M0PuW16Un7jhs+q7y4Ic34wkmoqzwO1SrK6+R64qdGzkGN38a6
nmqybc4FdqilapB+rHDwPB2Y/i3qVVn905W9SfcUSgmSfB/k86nO48a332YzEEe/
QWavHFF2Ex5gCmGWo6ISIN+Svxc8IAwOb8RQ6aCVaKS/lab+XD90RRTCUSJ42Gnb
lVdnL2oTplbAzlxwGzvt
=YQGB
-----END PGP SIGNATURE-----

--c4ATLI8HJzklxeaH--
