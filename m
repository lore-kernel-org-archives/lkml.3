Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaIAPhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:37:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44971 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaIAPhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:37:19 -0400
Date: Mon, 1 Sep 2014 16:37:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, nicoleotsuka@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20140901153701.GE29327@sirena.org.uk>
References: <1409296332-39318-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hjFmXiTvfEJBEd4m"
Content-Disposition: inline
In-Reply-To: <1409296332-39318-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hjFmXiTvfEJBEd4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2014 at 03:12:12PM +0800, Xiubo Li wrote:
> The 'big-endian-data' property is originally used to indicate whether the
> LSB firstly or MSB firstly will be transmitted to the CODEC or received
> from the CODEC, and there has nothing relation to the memory data.

Applied, thanks.

--hjFmXiTvfEJBEd4m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBJKaAAoJELSic+t+oim9ezQP/iq+xwP3e+Cl1cHOnMtPK3cQ
BU6mMZLExN7KyMuAdFFO6O8z45HRcDZNQljday2KbFUnFLWHsENuHoI+cvVg3zJl
bpQSA064rEeCy0NE5jE/9p9EkRdEfALg1l/ixXDgzvJhb2rZ+DHF+UlKxQ9FmkoE
2IeWmMSTCqBJixmA6e2umQIEGfIQlrGZe/EbKYFrYBXEVhJwMSrj/uuzD4Qy1vu5
xL5GpZM4k+8KsBtfcnDgZKJop9ptGejs5yhmq+eHYBKx8LlL2OEmg4//jYcbPWVR
bJXsSM9urj1dY42eaSr1iRfekPFMz3X8mKlnE6O0FS5fTMVAzUssUHIErqy0oQwa
1DL26aKtz8f6iTsvs3GAgcjEgMCi47kpQ/Ch9ltcmBPaurFpW5jnODKMNZHfnpnt
bZmBp3jbU6RaXeA86wmhQqQtpHsliI7GSlSiqrnshTcTXgOPTOoLsGLEzevNToB2
8OXiXHNUV92T/QRv8guwFUHGf6gnvv14jC1C985iHqfRigRx0M6mt05EZ9ytCSGb
9P+gEeRdNrqu+ps51dfDYc/FFfVnNPSkm79XKaFY+J9KI/xCyq8uELAPJquGyVrk
iUmV2p54l19K26JqhAKa9Nexk+9a4olQ9EBDRgKZvXiIuaVMQ2f+eNVas4n7jqSo
n3245u7juufEH2Kqpmnv
=1HP2
-----END PGP SIGNATURE-----

--hjFmXiTvfEJBEd4m--
