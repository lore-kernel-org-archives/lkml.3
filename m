Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaLVNxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:53:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43943 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaLVNxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:53:39 -0500
Date: Mon, 22 Dec 2014 13:53:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222135301.GQ17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <67cea1f0a74c333ec2048c7796cda37302d45e95.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJEqbsikIZBgizPR"
Content-Disposition: inline
In-Reply-To: <67cea1f0a74c333ec2048c7796cda37302d45e95.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] ASoC: dwc: Iterate over all channels
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UJEqbsikIZBgizPR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 04:18:06PM +0000, Andrew Jackson wrote:

> The Designware core can be configured with up to four stereo channels.
> Each stereo channel is individually configured so, when the driver's
> hw_params call is made, each requested stereo channel has to be
> programmed.

This is quite unclear to someone who doesn't know the hardware, is this
a bug fix or a new feature?  It looks like it's a fix...

--UJEqbsikIZBgizPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCI8AAoJECTWi3JdVIfQ4UwH/inEk5U0iocLQ+aTXSE3Atnp
VM/qo3kMfH+Dd+B02dxwB36/jJZ7EC/Xs77iI7lWZlaOadKgK4ZctfLXkaTsDQ4V
ZbELnBVSGR12/6mjWCRz60YzavpVgX0/ooLrFf+pCGGE39Wnw0w/y3JCowXfB14Y
jIfsHV4pMb+kj6RbAZ4LgoIrHPLEPCNhMuAUPR1E1HMOo+HAnP/ECY51mQs/Wjyf
ttdekwDJQv1YpsWr8miNCK46o1m4VF4VYdyXJBvZurMdD0OY1w+IFuUH7t/IvVqw
KRFJymTXpTY5cd7y1CXKBPeoBdFb9WEMjOW2cxftmnLCZgqE8l3DnC9Te1ntiTU=
=DUQ4
-----END PGP SIGNATURE-----

--UJEqbsikIZBgizPR--
