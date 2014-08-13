Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaHMKhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:37:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33144 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaHMKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:37:36 -0400
Date: Wed, 13 Aug 2014 11:37:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140813103726.GI17528@sirena.org.uk>
References: <1407920746-7534-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YxHrAKo4WTx4SUzr"
Content-Disposition: inline
In-Reply-To: <1407920746-7534-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: wm8994: Demux the microphone detection IRQ
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YxHrAKo4WTx4SUzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 10:05:45AM +0100, Nikesh Oswal wrote:
> Current code only allows direct routing of the WM8994 microphone
> detection signal to a GPIO this change adds support to demux the
> interrupt from the main interrupt line of the codec.

Applied, thanks.

--YxHrAKo4WTx4SUzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6z/jAAoJELSic+t+oim9ID0P/iycn1S4WadkDs/QFB/Cr+Mu
QIOz9ztn1Lq8Hjdx925HeVcYhpW1GN9g/lqSEqBS4p06jn96qb9CSGvTNEHlgfdq
o7p3aIIJX47+nC5Nl/1P4ZSsVk+2AquGSDpuotEGe+irTbUdwl66zcPKKHOUKro7
ZsNB6aRxcnV8fx8CpEGUAa1BHgO2xkIJcJ84W93KpSDoLko32GmP0puFrRBzHgXj
IacK0ocwiwJxYa4jj4i215sXJpYfZ1iZwgNbexFAdeHqmhi7DuTJ4c6UqL2nymCA
8d+bM6uff9rnmCTDoFroDf5vncxOiNb5v3/CtDZl+nbkiPty/2vY/XuKhWZpXKvh
2A/zjlW1Hii1pUY6QXuPfhmc9YqtYZtKXl93nl+302maGsDeu5sfDwRCIB8LFLqR
vTAw7UG9d5AQWCG2obBGlDjRAfbQX76+vDwpweWiRZizMrQUuzxYoPz3EFiccRV8
b3mNIK94P3+xDQZiUN6cQC3xWhX2ln6zz5eJqpRJpxW6sPsQoYLuABmnK6sa5exz
XN4kzO4J8YfFNre7ZB2wcNHVl/BWmRz0Ff5Kki8q/Z9HRIqy90iYuzsEM6Q0T6Gg
DE4gefyn88HDgt2eHfgG/U2lsMt79Tu7Q4VSx5PI9ISF6PH8qO3M7bKsfblNXhZ/
aXSUCYVxaZXpRgNMPhyr
=Zsc2
-----END PGP SIGNATURE-----

--YxHrAKo4WTx4SUzr--
