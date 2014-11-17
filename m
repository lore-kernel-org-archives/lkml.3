Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaKQXJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:09:08 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45397 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaKQXJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:09:06 -0500
Date: Mon, 17 Nov 2014 15:03:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, "perex@perex.cz" <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Message-ID: <20141117150300.GG2722@sirena.org.uk>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com>
 <20141111170432.GB25738@opensource.wolfsonmicro.com>
 <CACRpkdazkS0M6G_gNvfKayZdrU+BMhSSF9iJp=fZEbc=+jDKsA@mail.gmail.com>
 <20141117095801.GA25618@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExIO7AL6tcaLjJBF"
Content-Disposition: inline
In-Reply-To: <20141117095801.GA25618@opensource.wolfsonmicro.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 149.254.182.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] gpio: arizona: Add support for CS47L24
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ExIO7AL6tcaLjJBF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 09:58:01AM +0000, Richard Fitzgerald wrote:
> On Mon, Nov 17, 2014 at 07:41:53AM +0100, Linus Walleij wrote:

> > Apart from the whitespace fix pointed out by Mark,

> THe line Mark commented on isn't a whitespace error. It matches
> the copyright line style used by Cirrus in other files.

Are you sure you're not copying a mistake someone else introduced here
or that if it is in some way deliberate it's a good idea?

--ExIO7AL6tcaLjJBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUag4kAAoJECTWi3JdVIfQAvgH/Rs0lTr63qbIiQi9VPlJctYm
a2R59elTbBtg7ezzVvaR4f3Yvvm3o5JQhfeaMp3xNFa9+w63nxODLP70bK9GMy6W
aSeLVdSnNdiQNvmtkkpFilB2aDk9rYkN5R0/xlaJufMTsLHC7958MTWg+epkjyMN
7Q4qOPkW4QAkbCm9HhL+WjDa5ME4frKDMxnCmERfMfhofXwE2kfrfQTux9yASgt4
9JCa15DYgNMsRBrXNzpTu1hKe9VAqK2lPcvU95bGbTtggGh+dcv+5gqpHJCg9vap
dpmZrDlo35y5EYccW5FzrTwWUknQprsenevg9lovtw0MVGC8vqsEjuP58RmJlxY=
=Vis4
-----END PGP SIGNATURE-----

--ExIO7AL6tcaLjJBF--
