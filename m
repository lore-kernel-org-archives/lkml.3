Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbbAHTwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:52:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45020 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbAHTww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:52:52 -0500
Date: Thu, 8 Jan 2015 19:52:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20150108195231.GB2634@sirena.org.uk>
References: <1419614378-25229-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Av1MWY1rjlqAnvVo"
Content-Disposition: inline
In-Reply-To: <1419614378-25229-1-git-send-email-jcmvbkbc@gmail.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 REPOST] ASoC: add xtensa xtfpga I2S interface and
 platform
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Av1MWY1rjlqAnvVo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 26, 2014 at 08:19:38PM +0300, Max Filippov wrote:
> XTFPGA boards provides an audio subsystem that consists of TI CDCE706
> clock synthesizer, I2S transmitter and TLV320AIC23 audio codec.

Applied, thanks - the revisions to the RCU stuff make it a lot clearer,
thanks.

--Av1MWY1rjlqAnvVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrt//AAoJECTWi3JdVIfQpEsH/39taBhvaryU1iekn0D0baHs
Gu1Rx9s5Z2EUqp3nLOaGOaoeyiNfLO3LKdPffzNOg72GSpZV7rtDS9Sibi+LMQW5
l3HeiTEkGmeYE5s0BBp1rqImid7UScTWw6PR0QY07ECUKZAYc+hG9vh8hlwqly94
nif2mjW14hj7+nhIIAqZnhwnas9VkRRoW3/td463a3it7vqyIpYofp6TzhgOj05v
NBKBUTJ7KSmFcU9AQFK9Zv6IG8ZiG1M4pgWvHLBO35VtUiXa9E86D+g9GKLVA8ty
07obt3Srhk0t5CjSBHWuEnQEj2rfKmlz4Yz29hAuSlQQijR7cFdxjhnUhM7kKGQ=
=RncA
-----END PGP SIGNATURE-----

--Av1MWY1rjlqAnvVo--
