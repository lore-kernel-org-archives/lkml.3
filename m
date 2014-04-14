Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaDNUrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:47:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33004 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaDNUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:47:24 -0400
Date: Mon, 14 Apr 2014 21:47:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140414204712.GG25182@sirena.org.uk>
References: <1397212209-7843-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Guq+xBHXhbnAFmh4"
Content-Disposition: inline
In-Reply-To: <1397212209-7843-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Use FSL_SAI_xXR() and
 regmap_update_bits() to simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Guq+xBHXhbnAFmh4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2014 at 06:30:09PM +0800, Nicolin Chen wrote:
> By doing this, the driver can drop around 50 lines and become neater.

Applied, thanks.

--Guq+xBHXhbnAFmh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTElNAAoJELSic+t+oim9iXgP+weBmtyfBPeAKMJC/zleWfsp
ReScJItytUOYqXncWS75lLIsr5wZ0TCa+t2xIrqLTqPYIfmJpCuU+tdtUElnPoSg
YQecB5SRZTuOFlxfcN+WGT4u2jMITKX0Kyr4ZMxhun+a52RBltybvaLUEXkfVGFY
ABv+blRda5+DYl4BUH9AX2XSXmxhqGRjmcjdXO1ZeUv2Z/R9U/6mE3xnX7BAanLZ
Zfo3p48zGyVDJFDXlReTfA//XPSkjZ3NDsmJv+AW9ZUE8yPEd9BdyYbdPChaPd82
klhQyy6o6pfu3t9kcLMpzm/zMsnwz25crchZYoL8LvOocs6k58wKIACp9vWPyZ+h
6oZlRm7ymlW48jvM3LCaCQhWJaKtmr2C0Ou/PiLA+BMw35ZKFUS1jNcomhY4fXl7
dETsMQQ4wkQO3GC5Kb18IGt/MJjKcM8AoNf23PGze01bDSVnpZa6nnfpOxau5B62
VcQ3AZvZII+FrbfH0Zy6wDWY66snEk2ikqF6fm24CMi5Sn86YWtiLrNRabZRsuLl
x3sGfrk26F4R7EyBpW/ahzCGwQNimEv3yRrXueRovFOzVda9OIfTPLapvuRjg/dZ
XNgrv21rlJROOKQb1PVb/o4n3tkgZ61pjmV1PhA52LfnCmGwlm7vJk8vXGXTn67D
6A3qw83BU1cVotT48CwI
=Pn5J
-----END PGP SIGNATURE-----

--Guq+xBHXhbnAFmh4--
