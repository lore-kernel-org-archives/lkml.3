Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3HEKdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:33:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3HEKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:33:14 -0400
Date: Mon, 5 Aug 2013 11:33:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130805103307.GW9858@sirena.org.uk>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
 <20130802105156.GA20577@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8l0epyP1oK4ZrwYy"
Content-Disposition: inline
In-Reply-To: <20130802105156.GA20577@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3] ASoC: core: init delayed_work for
 codec-codec links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8l0epyP1oK4ZrwYy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 11:51:56AM +0100, Richard Fitzgerald wrote:

> +static void codec2codec_close_delayed_work(struct work_struct *work)
> +{
> +}
> +

Having a commment here was a really good idea since this is the sort of
thing I'd expect someone to come along and try to clean up otherwise.
I'd also expect just passing NULL to INIT_DELAYED_WORK() (with a big
comment attached) to do the right thing, though perhaps it doesn't.

--8l0epyP1oK4ZrwYy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/39gAAoJELSic+t+oim9XTYP/iYabC+/qgKHpA4n52P0m7ri
4HVGeTK3A+6Ecfm5IUUyRwEZplZmsLXyfefXwDX6S1vilM39VmXvLJyDwV0/YMOB
AWXncqXfijqTtcVtsB6L4I4s9rAHFxlI7Dt6TjRnbwGfeWFJPKxGkYwG/ndSAWXW
gtNfekQIyLdEPQ/JBndoyZf5hcEm/+Kw1aeAZkoc9XgFrq7VEOs3tsKo5nN8rJaR
JNBF/tai/BFK14SDFkj2kiGIID1wnSOR1BqBxfrNeU6TLQzNjstfKRY/J3XRGkAF
SUxWWkacQllYaUsLD1vV8kfIKgA9A7j/4iovBsvMIBiJDNrMCsKZkXlTKeUIDdq2
VrsHeB+idGeetWUCxd/FUQzhniwB3+MniztN9JJTPkSMF+adQMx8VQZvnPRluRnd
5cWLZwByUTrwjHrctwV3FWAuXVM/HCcPnr+xytgRU2s5X0ZlCyDKv1Bj50/S4Lpx
o9RFwf4cyCm19SPprNq5AhQWTWv0zzWj2xW1PdlTofmWhDnzIz0bHjiJyhHaLz0b
0LV27GXnmGjnt6kPXyJKux1aEkZ/MbN5WLD5b7amIYu/iMIKDk/xFDrm0Z0NTtl1
Dh4wBC3Wqv7QdkcIeVaijmo0B7hSbj8WrsldgdVJqng/ClwDdGAtoQ82pBXYheKn
TDmcR8/7YLVYqq2kmuO8
=AGmS
-----END PGP SIGNATURE-----

--8l0epyP1oK4ZrwYy--
