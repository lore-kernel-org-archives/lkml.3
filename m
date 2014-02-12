Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaBLRwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:52:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40993 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaBLRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:52:13 -0500
Date: Wed, 12 Feb 2014 17:23:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-atm-general@lists.sourceforge.net,
        Richard Genoud <richard.genoud@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, netdev@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Rutland <mark.rutland@arm.com>
Message-ID: <20140212172342.GI28112@sirena.org.uk>
References: <1392012586-30790-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+NAfxSaP7cKOSWOx"
Content-Disposition: inline
In-Reply-To: <1392012586-30790-1-git-send-email-voice.shen@atmel.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/2] ASoC: atmel_ssc_dai: add option to choose clock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+NAfxSaP7cKOSWOx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 02:09:44PM +0800, Bo Shen wrote:
> When SSC work in slave mode, the clock can come from TK pin and also
> can come from RK pin, this is hardware design decided. So, make it
> available to choose where the clock from.

Applied, thanks.

--+NAfxSaP7cKOSWOx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+64aAAoJELSic+t+oim9HdEP/1s3b2zCDKiZwxz8pMZEXXZL
PLWDH6glrCLjH0UBXgXvlC2wVgjNlX8EK8HCBWTYBYKEEM0d1TrPojWFG+SMptDV
41WSQhbPOA7zsuP8dWqk6DwGTgTKgfgSd9G6UZQ8EQ9C87xwvpeuCj0QQNsYYHt8
7YhksW+zOl5qXuW1Vcf3UX7JFgQ/ihQOPAp+g5CBjM0BkX2a9bH44qWtWNnS9FJo
vt4GWngybTU/NSB/PQ+bF0abpnGuu2qKjQjc73GBgtCtxkn6NNyQuqi0hPF/PiDP
2ShBveB6k9UOrYw1qyxzh/ojXNRpBYyRAO1uEKU9dfBFVhri9I0sVGR447h69NEy
068FPY7kjNYpasyK8OF9lUQzk8llZvenapVhjgaSCV7oqygix4p4S+TetsOJ+/3m
MuY8Y8XGipyXxRTCI4aGynZp2I4XsQRCXQJWFjZdJWU6i1/2UZQ/YJIuyU1NcyhK
vAD0qyigXsGaYLyGgyB4wQcG2q8ugL+DnqYygc2/QWPtu2fG4m2P5ca/tKXomBET
ItcQoVKGOOBpuXY2IG+nRs991r9rDVsiMBYRxd1t9lX7gbTITigIln3JuW9Y8eQx
Qpb/PnzvP7YSzSgkd2bKFMv9jxffekTlhG+PYATVlYY2gaps/5JnuHh3FwR/kRUq
vCUR3GvJPsUlOPJRVskW
=H++v
-----END PGP SIGNATURE-----

--+NAfxSaP7cKOSWOx--
