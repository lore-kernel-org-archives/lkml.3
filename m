Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaCEDkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:40:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55874 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaCEDkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:40:13 -0500
Date: Wed, 5 Mar 2014 11:39:35 +0800
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, lgirdwood@gmail.com,
        fabio.estevam@freescale.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        tiwai@suse.de, s.hauer@pengutronix.de, timur@tabi.org,
        linux-kernel@vger.kernel.org, denis@eukrea.com,
        Guangyu.Chen@freescale.com, mpa@pengutronix.de, shawn.guo@linaro.org
Message-ID: <20140305033935.GY13126@sirena.org.uk>
References: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
 <1393387175-15539-2-git-send-email-Li.Xiubo@freescale.com>
 <5311DE70.7000901@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tAdHiH28s3ybHVSb"
Content-Disposition: inline
In-Reply-To: <5311DE70.7000901@metafoo.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 01/10] ASoC: core: Add
 snd_soc_dai_set_tdm_slot_xlate().
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tAdHiH28s3ybHVSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 01, 2014 at 02:19:44PM +0100, Lars-Peter Clausen wrote:

> I'm not quite sure I fully understand what this patch is trying to
> solve. It adds a variant snd_soc_dai_set_tdm_slot() that instead of
> taking a rx and tx mask calculates the masks based on the number of
> slots? In that case I don't really see how the xlate in the name
> relates to that. xlate is something you'd typically expect in a
> devicetree context. Maybe one should be called
> snd_soc_dai_set_tdm_slot() and the other
> snd_soc_dai_set_tdm_slot_and_masks()?

> But another question is do we really need this? I don't see the
> problem that is solved by this patchset.

My understanding is that the patch set aims to provide a way of using
the TDM features of drivers from DT, providing a standardised format for
expressing the TDM setup in the DT.  I've not looked at the actual code
yet though.

--tAdHiH28s3ybHVSb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFpx0AAoJELSic+t+oim9SbAP/0HT7RHMIYW0jx9cScjgEoZN
HC31kblOQQdIn1WVPWk2NLp26F3OFufvwj173SVkO4QZ+A8QK5VGaqW4J2aomBiS
/4u4rjpP97P3i6MYgzolJI8B3aEQl6yFOmvkloCvMQuGvEaRHMYXuSAx6bUOCv4i
ddDhHgqVnE5qdq3dv7IDSC6YD0nJZJpzUZqecehDakFttBujXZ0cvyaYiab/sgkc
oGzqjnIgEmlERIoyIZ4c+5TvQSlMKhXTorRytrmmSmuNerLsFXtyRXoyUy14l7d2
MBoTDuFNa2iPa0bGEgbKcUsK0j3BnESjBHdvw/T8XrJuntjot6/oqeMU++eYm+rp
job+tbWXKlaJPIuZqMNTeEbbjBswQlHlBAYYQAMWr7+2dm5vdpTVSFy2TykFB2GY
sFANYuYeQ5fPPtBt1P4M0fsTxr9dJgI2jU+M1Wb/i8pn6K/S/9H2vvxPbjPPHSu7
SpzpE6GvIDfUzv62wAZgRUegdsTHR96TEq8Snz/t7Scu1GKRYZSV2HzSrkr9TF/h
vnrB+iGzoIpXPJ/dvzdChFa+T2KjOb/qLmq6A3QRQVikZck17f1w5hz46dl9P8ew
1Zi9w9KBsit6ono0jHMru3PfaLnkTJOKbAgkKiMFAzZT6ooUhU4O/+a9RTNh0UhD
9H8C0+Ij+HgkZvqBGH1j
=yGOo
-----END PGP SIGNATURE-----

--tAdHiH28s3ybHVSb--
