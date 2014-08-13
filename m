Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaHMLFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:05:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33196 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaHMLFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:05:30 -0400
Date: Wed, 13 Aug 2014 12:05:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Message-ID: <20140813110504.GM17528@sirena.org.uk>
References: <1407494479-9877-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eQwIhY+Mh5cQwJH0"
Content-Disposition: inline
In-Reply-To: <1407494479-9877-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Make Synchronous and Asynchronous modes
 exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eQwIhY+Mh5cQwJH0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 08, 2014 at 06:41:19PM +0800, Nicolin Chen wrote:

> The previous patch (ASoC: fsl_sai: Add asynchronous mode support) added
> new Device Tree bindings for Asynchronous and Synchronous modes support.
> However, these two shall not be present at the same time.

Applied, thanks.

--eQwIhY+Mh5cQwJH0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT60ZdAAoJELSic+t+oim9ybMP/0/F7Tr/d6KL/XbxzCsUVli8
X516T8JLDNJ0nHUoUJIR3j5zN0mOAlzXt+9OzDX3Nlf5JviVddIc14UH3xUUq/Xq
g5YFsdnyf8WFXQmhnqsdWCiifJ6WCPIwTEa5zPpNAj0Z/grVXTCRtKIkmFprNgNM
73BBkhL8mmTSj31HnVK6S6DUXUPAAlpuVcK/ynVrsP9TE//lr8Pmgb44fvqnnm1Y
k3aSr4LtkPrEojc5USyy75TnNHLy/WQY5urCbGP08ggUICyQPpQGM9p/OZ0Ob2rW
4bcOP40FfQ5M5VIqGP4OyDfWsqyC+kYI6YaJWZtz5qstuOKy9pPMRg2Pakbv0xYg
KPLU3HJQTAFuNkiPQhhXiRinJE+XoBxUqBF/fpkLrjPIPi8oKzp5c6RiTl6oI47Y
NzpF2IvkVkDYs9QsIFpJhM7o4S1YTRfQpY543UuWwIcqAE2yWahe4Ad7JcxZ+7xz
6XTnHf2l5lwj2QK3s5N/Avha/KZCLFkHuGu8swskO4Rr+92KSewVGNuBc3CSsZ3y
s8VYRePWOdISdiDYwyyUNR8Vknckq2Pi6vEjMNFts9KOIHUQixLzK3Cpo2B9i644
Vy3+yBvDpjGb+2DuIubziBoc9io8s8KVk7B+AyEcjPDcKBnyOFFhO8MNEQLiIn5J
Jcq8SjNxGE16s7X4sb+x
=afrS
-----END PGP SIGNATURE-----

--eQwIhY+Mh5cQwJH0--
