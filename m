Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaJJQug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:50:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44753 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaJJQud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:50:33 -0400
Date: Fri, 10 Oct 2014 17:49:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141010164959.GG18557@sirena.org.uk>
References: <1412957836-2186-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8sldprk+5E/pDEv"
Content-Disposition: inline
In-Reply-To: <1412957836-2186-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] ASoC: dapm: add code to configure dai link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8sldprk+5E/pDEv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2014 at 05:17:15PM +0100, Nikesh Oswal wrote:
> dai-link params for codec-codec links were fixed. The fixed
> link between codec and another chip which may be another codec,
> baseband, bluetooth codec etc may require run time configuaration
> changes. This change provides an optional alsa control to select
> one of the params from a list of params.

Has anything changed since the previous version?  I've postponed
reviewing that until after the merge window given the way you were
ignoring feedback and the approach of the merge window, is this a new
version or just a reposting.

--a8sldprk+5E/pDEv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUOA42AAoJECTWi3JdVIfQuLIH/R4q5v7R4FJQn2otp//iuU9H
Og5IPFRjDjULd3zCqO0TSGjU1/dBoVIRdyVmIfQd/4mcRn3jkCLL1ThcYX13jt6v
41TClQe5dENeNvsJaM05gaXncvXy8tK76rCa7/6xEoKVcJD1K/SAYGCqxb6yednU
mOtOzQKasTTnABNTlEx87HqzyZCVgl2fYiRkL66tFD7N5HRWIAEcnFuf2gzPA3x2
cLdvJg/TCbMJp0yc9aw/FdefKVM9MqjEbsuJPH7rKWpyfMo8LDic574QwSg2yE6r
w4vSZbiK3dhBShGBuAZMdiRBqY6VcZ5UloHLOHbVFuwlLU3KWa2MPQlzUEQ2boo=
=vUP3
-----END PGP SIGNATURE-----

--a8sldprk+5E/pDEv--
