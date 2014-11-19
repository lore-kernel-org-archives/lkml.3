Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbaKSKq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:46:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52931 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaKSKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:46:57 -0500
Date: Wed, 19 Nov 2014 10:46:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141119104636.GA22111@sirena.org.uk>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
 <1416336354-32148-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lYjFa3qL1bvncypl"
Content-Disposition: inline
In-Reply-To: <1416336354-32148-3-git-send-email-lars@metafoo.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] ASoC: Add helper functions for deferred regmap setup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lYjFa3qL1bvncypl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 07:45:52PM +0100, Lars-Peter Clausen wrote:
> Some drivers (most notably the AC'97 drivers) do not have access to their
> regmap struct when the component/codec is registered. For those drivers the
> automatic regmap setup will not work and needs to be done manually,
> typically from the component/CODEC drivers probe callback.

Applied, thanks.

--lYjFa3qL1bvncypl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbHULAAoJECTWi3JdVIfQg8sH/1nUhkNLtp7h1QWJzYUrLhbx
CbFejKUrciZwKJQZa+NGgXPXcUy1x4XiK2JJ6NeGsDx63tmekzKMT8cN0Cm5k4ue
8RI/t4A1LNX372GRbAYFv/1xkg7rqdMPvGwqJccXti4whfg2Bz9oW8gAdPviAmpb
BeNC6WD2OaxMgESrSvvio7YOTTCUMqbQosCiMJJzdo7Yuehxon1k41mArKJdzlWj
0dlhdvElT9WDBRT+QN/hsRCvimnBPb02KXXZdmMH/qZtM9dD0ZOAlCjl0XSw8Wyi
l7lkRsGCmVEMm8xs7NA5XQXJMe+iqvcv07OmMDdAuumh9ikM8ZQj5h/vh8rFCfo=
=mV5B
-----END PGP SIGNATURE-----

--lYjFa3qL1bvncypl--
