Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaBLLKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:10:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40701 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaBLLKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:10:48 -0500
Date: Wed, 12 Feb 2014 11:10:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org
Message-ID: <20140212111033.GD28112@sirena.org.uk>
References: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
 <1392191112-27028-2-git-send-email-Li.Xiubo@freescale.com>
 <52FB3E5C.8040701@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <52FB3E5C.8040701@metafoo.de>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2 1/3] ASoC: binding: add tdm-slot.txt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 12, 2014 at 10:26:52AM +0100, Lars-Peter Clausen wrote:

> The current internal API for TDM is very poor, I don't think we want
> to expose that 1 to 1 to the devicetree. Since this means we'd have
> to support that forever. The first thing is that the semantics of
> snd_soc_dai_set_tdm_slot() are very unclear. E.g. some drivers use a
> zero bit for a active slot, some drivers use a 1 bit for a active

Yes, and if we do end up using masks we need to nail down what's going
on in the DT.

> slot. The second thing is that we are not able to specify which
> channel should be mapped to which slot. You can merely specify
> from/to which slots the CODEC should read/write and then it is up to
> the driver to guess which channel should go to which slot. In my
> opinion a binding that allows to specify a explicit mapping of which
> channel goes to which slot would be much better.

It'd certainly be good to be able to do that, though having a default
would make life easier.

> Also those are four different settings. In my opinion they should
> not be expressed in one property, but rather in four. E.g.
> specifying a tx_mask for a rx only device does not make much sense.

That makes sense.

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+1alAAoJELSic+t+oim9nZYP/3hDlhlwKkSGrhTq4UqQmDUs
50UahwX3aVk7gf9Nyk6064S6Jf/jOAb7rIqodg8wVAEdAp72rmLFnc787pmHaD2G
kfqCme95VA7Mwhzx9ZH0TysJMpO1UY08NecRyH2NgnaYakh9F3qZeVGetrzDSYq2
bQoq8okB+GKYLM7hM2IX8QFWPY13YuMAOkRbMas+tOBGwPLh8uwsWsevHwUhlTmN
RFj6iTnBvtFZsUx1S2RO7K4Tn5thdqbifFY1uB6hpFg+IxIuj50P5aE+lcTW93Sj
0Lolw83n/+/k+pTEhabEFlXVJfrLP5DwH5W4Hr7XlYjHJNB5rbjDeDA62yPnln8d
1m2MHJKjAWJW9uAYGP5UBHTeSHvqqETVLqpLOMoXbDnXvghHZksdMdHXjgz4N4bc
LK0c1fgqtXrM2xY02DJelrins+o/eUiJnneKkulKW+9KbQaUWAq+z1P0lkYikmv+
EL991/94ZbO/ihbVH2XkzQfn/SUkZiBTQzS6OkoJ9q4M4pOW6OI0guMCJ4CMeq1O
GGJJnGoxV3y8s4V0lhR1Hlz0+7I8eMOvAlZHFSOz4ztKcOcToNftDuXEfyq8Loc9
xZqp9PZQ3uYF3dK0JcU3cbu7DP7xZ3yAFC3uJ1+9YyitsFa/6HQoQuDNSayeEvcJ
IgSktKFXZ9A9bnGAuQ5U
=TT4O
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
