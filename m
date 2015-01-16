Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbbAPMaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:30:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38971 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbAPMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:30:12 -0500
Date: Fri, 16 Jan 2015 12:29:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Jie Yang <yang.jie@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Engelmayer <cengelma@gmx.at>,
        =?utf-8?B?UGF3ZcWC?= Piskorski <pawel.piskorski@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20150116122938.GL3043@sirena.org.uk>
References: <1420331724-5579-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/0D4jGRsNl8cPNu/"
Content-Disposition: inline
In-Reply-To: <1420331724-5579-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] soc: intel: sst-haswell-ipc: Remove some unused functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/0D4jGRsNl8cPNu/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 04, 2015 at 01:35:24AM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> sst_hsw_stream_unmute() sst_hsw_stream_mute() msg_set_stage_type()
> sst_hsw_dx_get_state() sst_hsw_dx_set_state() sst_hsw_stream_set_write_position()

This doesn't apply against current code, please check and resend.

--/0D4jGRsNl8cPNu/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuQQxAAoJECTWi3JdVIfQpu4H/RY78QU5yPMowGJHvKjaKztT
NDHX8kmIHlmh/0gPhyT9B/dD4k0iiGqjh3dtoh2UhzOcdO8u9or6qBu9I+iqLejL
cpCL4bAsb0vzn2WCHcKN/zcgLYCfxgomGgqHxBefe48hbWXaY7NPrShCbQv8YGZJ
odzdf1/ctB+kJoZ0/NLc6eL8+WFc+FsI7MwhRIrV0npKvvJsAOmMkTClFkZ+k6+T
lNSx7kFWZrJ3rLZAyd3L7Djs4TPjdepcxLiJCHJyUBKq2SOnIsEPtd2cUpco11Qf
aoThHP9lubvff318tn7EVT2oN8jkx+DEIKJLv7v7xhAE2Va69sJpI1TjhffSTB0=
=cp7U
-----END PGP SIGNATURE-----

--/0D4jGRsNl8cPNu/--
