Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaETV7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:59:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34738 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaETV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:59:15 -0400
Date: Tue, 20 May 2014 22:58:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        linux-samsung-soc@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140520215854.GY12304@sirena.org.uk>
References: <1400191076-28279-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <5379E284.7030700@gmail.com>
 <CAFo99gZ3kVGn04we5OtRtbkceYRs6SiHXRyoX1Gb-SknJH=z=w@mail.gmail.com>
 <537BAA2B.9090906@gmail.com>
 <537BC744.8020601@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vD5pVGp8mlWv9jf"
Content-Disposition: inline
In-Reply-To: <537BC744.8020601@metafoo.de>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] Fix for possible null pointer dereference
 in dma.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0vD5pVGp8mlWv9jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 11:21:08PM +0200, Lars-Peter Clausen wrote:
> On 05/20/2014 09:16 PM, Tomasz Figa wrote:

> >Still, I'm not too experienced with ALSA and ASoC, so I might be wrong.
> >Mark, what do you think about this?

> Given that there is a patch[1] which removes the whole file I think we can
> stop the discussion about this patch here.

> But for the record, substream will never ever be NULL in this function. prtd
> might be though if the DMA completion callback races against the closing of
> the PCM stream.

Yeah, what Lars said - obviously the patch removing the driver is more
comprehensive!

For the record it's very helpful to be specific about what the problem
being addressed is in the changelog, if it's not obvious what the bug
that's being fixed is that'll slow things down.  Please also use subject
lines appropriate for the subsystem, it will help your patch get
noticed.

--0vD5pVGp8mlWv9jf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe9AbAAoJELSic+t+oim9vdwP/jt48ImlvqwrXCC0YmJvyPEt
Tm+9QQoCZHzIoqv0Ij7MfyB4gfpRLaEElHj97S7ebUsgjEe3l2bSzcmZkL34ElWd
bxheooyW4SNfy5lMD9M/cSLFkLPt24MsRJPID6co5SF00t5CbuPZweKvcXSPkY78
H8GrLoPMi5iv4E0Ef87F8nxZgQEUPiTnlNIgFVusXUIJ0kX26QAFknZIj0OFTGJm
f+dnEUkorZQrMi8aeaGHCEbPmwE8hiryUjIiJeD3BA+KxZQDXSr3JmcGzoo/BpwH
cVhe2OOMtmkK95ch9Ck6aUdkBJYiRihN3cfeHzysdqDP2CfHy/vYhdMj87HAB6Uc
kU8KjMPXIIgxBoPFNosR5h3Sw32R7FGj9rADsive0ToaCM1mml+NAqt6b1lCivFl
ua5EUUp+/ePebZvu5cFHk3KHn/ScY4rn+fQMAhqULBw0qGCATUfXPOfdYYnRYOlK
KchkP+iqs85d1GBdABBZS1Tzu8GlwGvoTIgPcJ3sNjrTRWZUY6lbTB2COQbNX0l+
DndEVNaRuswfTp9/e+lfXqSTeEuYgh+iqLIRmpW+ZOeOLXCBsyVTvaSuMPEaNqKX
SH2iyc3fSwPhE8kz/Ffe2kD55IZUUn75xADIfufST77Tyg0ETDcmPtXlCk4oI2I6
5LDmj5A/Ts43uKI1gghm
=S2g0
-----END PGP SIGNATURE-----

--0vD5pVGp8mlWv9jf--
