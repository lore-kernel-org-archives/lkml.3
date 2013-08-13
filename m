Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3HMMCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:02:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49392 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3HMMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:02:31 -0400
Date: Tue, 13 Aug 2013 13:02:03 +0100
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
Message-ID: <20130813120203.GW6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com>
 <20130812233641.GL6427@sirena.org.uk>
 <2472314.6b8DcBdcjO@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQA5JmyoyfznAa64"
Content-Disposition: inline
In-Reply-To: <2472314.6b8DcBdcjO@flatron>
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


--xQA5JmyoyfznAa64
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 01:49:53AM +0200, Tomasz Figa wrote:

> I've been testing this without any significant patches, like PWM, CCF or=
=20
> DT support, just everything from the branch I pointed to and some board-
> specific patches to help in debugging.

I retested with the SPI patches you sent separately yesterday which
didn't make a difference for the SPI issue.

> Anyway, this is the exact branch I've been using:

> git://github.com/tom3q/linux.git v3.12-pl080-devel

I can't test this directly as it has the DAPM bugs I fixed yesterday
in it (those patches will hit -next tomorrow), however it does look like
there's nothing else relevant in there...

--xQA5JmyoyfznAa64
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCiA4AAoJELSic+t+oim9ep0QAJWIMmIJR3Y9j/6Ui7SEUO2Z
WEf3zdq+jDqLw/rUkHYhCKKTxokUsDpuDwuFmc/oc9sMLIU3g7bXrEu1PTTu06HY
5Gm4aIJ05E9170oS+JsMwuBBAUoIh30v9M2/B3yglACIkHB2QRJB+gPVsWIF4EfU
xOvDBZ8oOiSAZ4JPichgaUf9IPOtuCic12IFR1Cr68SGNyKr3QvxOBjpvubXe+C8
yqVOXt6nlABHX8yzzwlqeAGztOmdWMiGpm3WFHM9DkK1PvJl15C4uSrBgBGs5Ptw
3j4f0qxEl6FDKiSlQ1BIg9HdFcpT+FQ8n60CB2MO78J25zAOeuWj9NGKArLAmdPS
AGkxAx/e/jASGTuk21Jo3PJfiF0g2dvw9HVdVi75TcT1erWW+gewgqqC6Hqzm4qL
f25qupR6d6OSHnpzGaBb11wayQjxX7W3IlS3IfddYAxNrSU6fM/+bjVcCgoKrYJ6
4A75fVv4XpRKY/zOVMjDFO77nZTWPh5Op2S7Ue9V/x1vFOTfa+Vpo7/9eDu5meJO
RlNkADdo5f9U9koY6PTRyIp7MfFTEx9GUD7oja+iIlwL5GXroSvGcYTYso1ymLqd
0B7kyMx5+zIEm9gJloP8QOofWQqvJwi2MYF5UCl3kBvyZgNcd4hs0wBzzWACltjY
/uQzui8buV6Rf5uf4LAI
=V8HO
-----END PGP SIGNATURE-----

--xQA5JmyoyfznAa64--
