Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaIKShp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:37:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35381 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaIKShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:37:43 -0400
Date: Thu, 11 Sep 2014 19:37:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140911183722.GR4015@sirena.org.uk>
References: <1410432139-15089-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U0B5otXy6WXfork9"
Content-Disposition: inline
In-Reply-To: <1410432139-15089-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] ASoC: dapm: add code to configure dai link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U0B5otXy6WXfork9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 11:42:18AM +0100, Nikesh Oswal wrote:

> +	/* add kcontrol */
> +	for (i = 0; i < w->num_kcontrols; i++) {
> +		kcontrol = snd_soc_cnew(&w->kcontrol_news[i], w,
> +		w->name, NULL);
> +		ret = snd_ctl_add(card, kcontrol);

*sigh*  As I wrote before in response to exactly the same code:

| Throughout this you've got coding style problems, you're not indenting
| the continuations of multi-line statements.  Please try to follow the
| kernel coding style, if your code is visibly different to the rest of
| the codebase that's not good.

Please pay attention to review comments, just completely ignoring them
isn't good.  If you don't feel some change should be made then reply and
discuss.

--U0B5otXy6WXfork9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEevhAAoJECTWi3JdVIfQPL0H+wcGMuYK1NxagI2N6mzs0/MJ
hm9RbtJhiXByUYFPoAbKHHaiedeuZQyzQhQX4rWmSiUXhrRApBNdFXbXBeO5Fuqv
cmJQpvWxv2aGhOMZ9xCMqeeLDNNxCay4omkchGnUQFzgWSGbtMK7+G1TDS7qlrJ/
/cLgwxsbaFvKh7D2rqLDCSZMICBtANBXPW/VfqDi544exZex+R37tp6KHCbywvx7
EaMQL/O7TUb1jK0ptg9EFtpfAuBiG6bQs0pWz7n3CdOYYzTTr911aj7e4zhzxrz0
+w+LKN9j8lH5UDcgmLFgxltaYvC9tSe8kz01Yzaeq9ZVoetT1buqvAh4izd3dgw=
=RfRz
-----END PGP SIGNATURE-----

--U0B5otXy6WXfork9--
