Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKFNkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:40:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45919 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKFNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:40:48 -0500
Date: Thu, 6 Nov 2014 13:40:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Message-ID: <20141106134028.GH8509@sirena.org.uk>
References: <1415278441-27866-1-git-send-email-peda@lysator.liu.se>
 <1415278441-27866-3-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2l43pqSnz0CmKuGJ"
Content-Disposition: inline
In-Reply-To: <1415278441-27866-3-git-send-email-peda@lysator.liu.se>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: tfa9879: Add bass and treble gain/freq
 controls.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2l43pqSnz0CmKuGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2014 at 01:54:01PM +0100, Peter Rosin wrote:

> From: Peter Rosin <peda@axentia.se>

Like Lars suggested just squash this into the previous patch.

> +	SOC_SINGLE_TLV("Treble Gain Volume", TFA9879_BASS_TREBLE,
> +		       TFA9879_G_TRBLE_SHIFT, 18, 0, tb_gain_tlv),
> +	SOC_SINGLE_TLV("Bass Gain Volume", TFA9879_BASS_TREBLE,
> +		       TFA9879_G_BASS_SHIFT, 18, 0, tb_gain_tlv),

X Volume, the Gain is redundant.

--2l43pqSnz0CmKuGJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUW3pLAAoJECTWi3JdVIfQLMcH+QFLZnLsbVkYTbkyX6BPNZdY
LVtY88PhKl0oio3dU66QDP6FfFjuF1TLDUyrpL4EgtGKVaSgo1NfqShQeF5DGfdR
sanU9WaVNoP6ZIAd1pI9KnCDPnu+rVlgw7rvBfNgUl750gOGitNia8aEAK7G5Hmh
sl0LqufY9LL4DQFrdHl8hu9b1tOF8Y/ojG/bPv25aLkJegTJz8D+dDaEWZNCdBOI
JRBQ8cz8J17t+dhi9pRyTR3wLIV1d32dyixYC14aYQgjXdcbaRc0DpCBuD2CITsw
1cIiPOq0JlkwzQKx6qd09XvdlYrxI7uusE1YRdK3apgXTkLSFJOe4uAgWfoPjCU=
=Vrs9
-----END PGP SIGNATURE-----

--2l43pqSnz0CmKuGJ--
