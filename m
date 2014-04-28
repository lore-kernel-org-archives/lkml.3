Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaD1O6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:58:48 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48896 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaD1O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:58:46 -0400
Date: Mon, 28 Apr 2014 16:57:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, broonie@kernel.org, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: ftm-pwm: Clean up the code.
Message-ID: <20140428145703.GB28443@ulmo>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <1395377590-23537-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <1395377590-23537-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 12:53:08PM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/pwm/pwm-fsl-ftm.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

The patch description here could explain that this is in preparation for
the conversion to regmap (which I assume it is).

Thierry

--bAmEntskrkuBymla
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXmxLAAoJEN0jrNd/PrOhPBoP/RV8RIpUjRikN7hOwTRVtjSe
9B14S8Op4idy0Y9bvSCCeB/HUnVJSoLDGeZCnjxckSdo4gmh+QoOiMqRIIWhYQwO
SxnRUTjYS6ULjZJVqinTe5u0CJvJb1dWcotY90nSUCEyduVMh2YcltUFzkrsX21j
OPD1vsOrDOKPIgw6ANAI+vHWPar9NdcvhLIIAbZKauLbR5/6IbkzU2OWuK9WYLIH
TZkz4itHytJwYrkXDT8RBAev3rdioG4JJob1Zi4FiVU4fs1z7x7CmEdVTiLOFVSS
XuuECvKnOjrrCWFTY8MmAb/le8ZukFiDBcvsRF3k/6DBf1DeJ9Rj3V981HqqUAZE
v+BaaZTBJoAJhRax9BMqfLLIX3S4H5A94iUQgY5NXOjV5bZ+37xLF58CgBxL2zvt
OBl4xX7YXPktiPrsSYLGqdvGVyVW5pWEjz7/fJF7inGzLC0iWX+gKqh/vmMFn9jS
gom2/fp42u+LG3gXjBrsgappHSVpVk6fhMrRIKIMQwGThQIx+p2KkI/nvo86MQhP
K3I4J2sncEbTVX6uMtZ8Exlkb5v/fAWKOShwjAwD/T/imasK+/ENKtGgwgt0mPqo
poned8t/WfpUVZ6rPfXReBfv+asEIMlhb5AaqlYwAExRNGL8L0GDGLCgF1G8YeZT
eMog+7xHxZDuo88ydkds
=ISXF
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
