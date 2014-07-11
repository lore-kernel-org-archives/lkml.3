Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaGKNEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:04:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59923 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaGKNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:04:08 -0400
Date: Fri, 11 Jul 2014 13:42:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jianqun <xjq@rock-chips.com>, Jim Davis <jim.epost@gmail.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Message-ID: <20140711124231.GN30458@sirena.org.uk>
References: <CA+r1ZhgB=BG5jsSaWBLMvRUjZ=X4gKJzv6KysyvPSOtFuUTbng@mail.gmail.com>
 <53BF2AB8.7050307@rock-chips.com>
 <20140711103221.70c856fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qWV9ymU6UYcl1Snp"
Content-Disposition: inline
In-Reply-To: <20140711103221.70c856fb@canb.auug.org.au>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: randconfig build error with next-20140710, in
 sound/soc/rockchip/rockchip_i2s.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qWV9ymU6UYcl1Snp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 10:32:21AM +1000, Stephen Rothwell wrote:

> Who ever gave you that advice is wrong.  You should always (except in
> very rare circumstances) include every header file that your code
> references things from.  We have over 20 architectures and many, many
> possible configurations in the kernel build system and the fact that a
> file builds for one is not guarantee that it will build for another
> combination if you depend on implicit includes.

Right, I suspect this is coming from the header minimisation efforts :/

--qWV9ymU6UYcl1Snp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTv9u0AAoJELSic+t+oim9BHgP/1k+2gVzXk3NifgKssLQkwSx
POIoUiLOTnQtNIW36CxW6IuoHfjdFd92Apg5m1BFQdjRb3+R/IEBrF0UpS0DyTW8
QCskXO2P9S8zwAxFrBrz05EwxuvaF+1tjAZKbhmQohB+XToQLi5CcPTZTbNqaICN
+XqzK8i6vgjWYwgZ9b6bxYrvwB16R/16Yl4sv/nVZol/QN2/F8NzqZf30V16/5+/
U+6PGZJM1xUhWvMbuWSdOotcLPmUWuRoMtfezWjJsFZ1rxhbdi0fvNoo/IZ+Ck91
m4675Lo7BSghFadjtkZ3gsUqsRaekb5KHW6UZ6WAa8kRCCEMZv7KyOtPvW2GhpyO
MMdwGduHTgypa1MFsAQ9fyF49rTCecS+TvWLOeWxx4B81gbQ4BIi41E6zl6qzJrX
XIWPuxlhhscZ8O+iOPFfJ5CzSV2d6Kv378fGy6AVPKkiQ0PmshztediVCiT8Q0Ro
KQbJ/vfh3gWVgD4fnuikuY0ViHKS8jUQoxabK7vYsXXd/VelA7aYcvEF0qISEaiX
/g4vH9kwIO4eBZe/K+MEG/QTVqYxtbhGbVNSVxJ5o+aGDq5Dv+IgazJdrlhkZMHs
wl26SAdablFmuvkKwp+Oqlyl1PnJ5mTTmW2evOnpuzFR2pO3Wc/MmjbdIL6hNbpZ
wSh6Lpwd8A0l/00SRvou
=CwhL
-----END PGP SIGNATURE-----

--qWV9ymU6UYcl1Snp--
