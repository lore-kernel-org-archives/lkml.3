Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBKM04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:26:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40358 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaBKM0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:26:55 -0500
Date: Tue, 11 Feb 2014 12:26:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140211122644.GJ13533@sirena.org.uk>
References: <1391669261.24190.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr/DzoowOgTDcSCF"
Content-Disposition: inline
In-Reply-To: <1391669261.24190.1.camel@phoenix>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: as3711: Allow missing init_data for
 diagnostics
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yr/DzoowOgTDcSCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 02:47:41PM +0800, Axel Lin wrote:
> The regulator core supports this to allow the configuration to be inspected
> at runtime even if no software management is enabled.

Applied, thanks.

--yr/DzoowOgTDcSCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+hcBAAoJELSic+t+oim9LsMP/ibUdsflAYPayZhjknLlf5mi
GVwmTxSj2vPy9y+jmnZ2EpuqHB113eBxufVaVNfDsYoPpi5fi+rUDWJeQko7zUxJ
gmfVmSER76v+51UEjsAkR8gdWxg4Cd0heacNrfoubOv7ZTpVSiYTXQAI/DaOWKRD
BxHGZPe+K7a5/87utcRUJTZbmV8JLjmBb7EVqVo6vtKbUsAdboP/fRFSI4xSRoka
8Sqn2HgOdah8frR+MrHLMd4gRbFWOls6ZSd05zlPu4Mhav1yMTkw1hgB0uYTyNBH
diuLnAc/SB/cUJdK7xmQ6EKVz77NdSgCGOIRDk41FPMqGTGylfNRNk5Ki+uZXynD
1Y/5K1BmPupqv6p9YC1tWsgPZ+voTRG4cAq72PE772DqQgm7L+CbR8+v2FogZPQ9
zWvKAQSH9MhNa93HjhznyYw7xyJpfk9qn1StSbYm+F2ZI3hIrqtbmLnq3nsH7ERa
KF0alIv+ulfLe1z0+62gyDglNQ/Qr7e6VxxAc7Fucqp3R0LteQMzpwEJdY9u1CFa
YKZX4TwhaqHn61T6LjNu8Os52Cz3Lldq0fCpt+5merAIl52uFf4QheikMKZT/Bfk
+ty3OwrSsEBaKgM1vAFoVsxbh5jKPpu0Ck/fabc/gNgazOIcLoqKskSbhB252Jf4
0YRO53lHVkdGYFEwWSF9
=/uav
-----END PGP SIGNATURE-----

--yr/DzoowOgTDcSCF--
