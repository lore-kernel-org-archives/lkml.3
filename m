Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaBTKyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:54:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47176 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaBTKyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:54:17 -0500
Date: Thu, 20 Feb 2014 19:54:01 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220105401.GQ2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-16-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RAbP3WyQYKsI2/Hz"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-16-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 15/17 v2] ASoC: pxa: magician: Update locking around use
 of DAPM pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RAbP3WyQYKsI2/Hz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:26PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--RAbP3WyQYKsI2/Hz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBd7GAAoJELSic+t+oim91HUP/AsgzjBWQP5f9NgIV0IMc1Io
80bPfDPvo/aFGkdcLFVCFPjzsA1tDoK6xAnutgGCVaY7lbGSDk2QcwXZh9FyVHq0
KIHr8tlb0Dkry1Sb1Ua7Boca5Ev/lwQOsy8FqTfLVtaqhGrcotH+ckR55kbTi3tH
4zdiNIj2krBFjPNOKzdKtqZQl1YhF7/5MKy8PCSZCgRrfGfitUGpdXDWGVrCEFQ4
ILCjedzali7TzlSwn2eOQNQQLN+fSdBPJlsBza0eh2A43OCsqwZQhyHBsdmZ8Saq
UhpUz7VXAVzsPVtXfwXukegqMEkgSsKrgls5bA5YgrlIGYsppWq5gxvSOCn6hSQE
+5y+EqA58LbHN7SrDhm476slIFSpGnqkc1wCX8xfkmQO9qPm3dU3DSC0LbBqwU+I
997HpPnAFU5eqO8tue2KqWxE0ZdWxn/9Vrjk2K8jxULbfX/FYNWu2UPEF4zxciRf
GFlADS1qQaEYL2F6zbQqYWNDFoh5UBnDeifTyXxJdLxn2snqYVx8WQEC4DDnu/wF
tko63hPcj2cDxsOM+7K9UDkIzMuhqHi9G5/A1Zbyti7xZAcQsCsViLNC5DtxJWL+
OBCPLG4awZT1OMnoEy5ishmDhn8PlOdjfKA91DpQZUTYsy4fLOgbXQ7PeVWSRW5E
o0TMkBkIEALtjvgR3fa/
=3afl
-----END PGP SIGNATURE-----

--RAbP3WyQYKsI2/Hz--
