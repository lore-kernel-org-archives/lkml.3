Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab3HMUaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:30:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60712 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201Ab3HMUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:30:08 -0400
Date: Tue, 13 Aug 2013 21:29:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20130813202941.GH6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <20130813185547.GD6427@sirena.org.uk>
 <20130813201816.GG6427@sirena.org.uk>
 <1686992.nQEd3xdoHn@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t8sZUJWWzCYn6PHL"
Content-Disposition: inline
In-Reply-To: <1686992.nQEd3xdoHn@flatron>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/18] spi: s3c64xx: Do not require legacy DMA API in
 case of S3C64XX
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t8sZUJWWzCYn6PHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 10:20:19PM +0200, Tomasz Figa wrote:
> On Tuesday 13 of August 2013 21:18:16 Mark Brown wrote:

> > 	if (dev->chancnt > 1 && !dma_has_cap(DMA_PRIVATE, dev->cap_mask))
> > 		list_for_each_entry(chan, &dev->channels, device_node) {
> > 			/* some channels are already publicly allocated */
> > 			if (chan->client_count) {

> > which is happening because dma1chan0 (which is on the same DMA
> > controller as the SPI controller) and in fact every other DMA channel
> > had references grabbed by the network stack dmaengine helpers which I'd
> > enabled in config.  The fact that they do that is unhelpful, it renders
> > the API mostly useless, but is nothing to do with this series.

> I believe you just found another brokenness of current DMA channel=20
> matching.

Yeah, at first glance the reference grabbing thing seems a bit peculiar.
I didn't research why it's done that way yet.

--t8sZUJWWzCYn6PHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCpcxAAoJELSic+t+oim9bxAP/0QJ1lRL0/9GWqrLeXp5Sb7q
yt/beBWYPnfQyGZ0dtWZZfnD4Ftfi8x/rzEWOkGPGsm0BqmiP0Szjb7Imm9Nd5WK
rM62iGiK+eZzTfcc6EaSXWZwf5IEJyrvqcqDjWNjDqREaA4jWSz/bFIYuk+djOL9
BiB5Q9C+AfzfwL4ZG0Wm+74pd/FR5rLG87H++86tJzYgaKeGE7si3UiPmUXAiUTN
cFW8MAEKjqD/eQkUN9gRrSl/sUx7adLEPLTdc3U7nPGVqH+unD2Qis5moBe3WKfo
ZRGjk4dfi2hC56EJIuTXUr9VkMcCMtmvc63l4thYEXxk1Kw36vWnn7pasEHlWTRT
TYUHRxWTIWxIt92Vv9Bu17wPIrh+99xCOwSmw2zsVE+hTijq6VErgtDTt2onx/S7
oG6IpmetjBprM2HPk0WZxj8glFl3o80nb/eFgz8fJCc9RE6lb5lnmutKZ6izRQYR
+oGRH46+OZXCWl7WlFO11ybmuJK2ApbKUJGiqUaj7xKBe5kCNXUnzM+Hn37kMaUl
GVZ1ENzmduPOpu8G3Kcc27VCANIgcC0iCrXe7ol1Wodpdc3VxYybFLIoHCYhEx0t
sa4Mwn/ApZRZZXsZtiU2YAA9IubaBwTcqKmDUgEUOqT8nwgL7tfTQMXIRk8J3s0L
edyU0gFv7A4OeFAskC67
=dMF/
-----END PGP SIGNATURE-----

--t8sZUJWWzCYn6PHL--
