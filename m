Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaIXIg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:36:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36586 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaIXIgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:36:53 -0400
Date: Wed, 24 Sep 2014 09:36:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Howard Mitchell <hm@hmbedded.co.uk>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140924083626.GC4015@sirena.org.uk>
References: <1411127431-31144-1-git-send-email-hm@hmbedded.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVmWh8UkjoBIyGkN"
Content-Disposition: inline
In-Reply-To: <1411127431-31144-1-git-send-email-hm@hmbedded.co.uk>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] soc-core: Fix volsw_range funcs so
 SOC_DOUBLE_R_RANGE_TLV works.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVmWh8UkjoBIyGkN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 19, 2014 at 12:50:31PM +0100, Howard Mitchell wrote:
> This fixes a bug when using the SOC_DOUBLE_R_RANGE_TLV macro in
> the invert mode. In the non-invert case, e.g.

Applied, thanks.

--EVmWh8UkjoBIyGkN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEbBAEBAgAGBQJUIoKKAAoJECTWi3JdVIfQT6kH+KAqrRLkHxTSyXNuls2Ke58v
TnN3PL7ENEWJRKi3wZKyEEBeFrP1ORttxoj4VdVd2zdkbU4DoQztvoKlHx0nHd7Z
Ye5TM4gqGHTeVW3BecU/q8ixNI267bCsScRzW2LS7jZojdubzoEEHRQjD6GCWrWU
KzXP6xmbN90C3G/rHbTEhD0cfnr9NVJKUWg4ZbAAItSbrM+rR4bOmXG8m5eTCqjk
H76sAzsB4pKODefXVQUtYOmDZ0st2l+egacU5oNi64BnCAHGdHqoQy3avJJBOhPM
bYaDE9aWxt+KsiYRV1sUvOzZ8OadlLZB8QsTufu8QOLZeh6j5PWGRCIGWWhhRg==
=V3jp
-----END PGP SIGNATURE-----

--EVmWh8UkjoBIyGkN--
