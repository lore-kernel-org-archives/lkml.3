Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaDNUbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:31:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaDNUbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:31:41 -0400
Date: Mon, 14 Apr 2014 21:31:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com
Message-ID: <20140414203126.GB25182@sirena.org.uk>
References: <1397225400-2769-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KVy3XSgRgEDVTe6j"
Content-Disposition: inline
In-Reply-To: <1397225400-2769-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Fix incorrect condition check in trigger()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KVy3XSgRgEDVTe6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2014 at 10:10:00PM +0800, Nicolin Chen wrote:

> +		/* Check if the opposite FRDE is also disabled */
> +		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {

I've applied this since it's a fix but this is *not* a triumph of
legibility, the ternery operator is often not helpful.

--KVy3XSgRgEDVTe6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTEWbAAoJELSic+t+oim9SbYP/iMzf8vQUEoMh6qZgtpcCJTp
/kvf4ZihGLA906RM+siUvfuhP7RAbnEyMRzMdlQQTXj1ck/x15SPhW+7vNoXw8iS
UE3YHazA8pBncQb60EV8VfVr3Hp38wxTp67TZLi80jAa3TEaYh7E3UqGIErqrapD
zf2sYeSxESQaa5vxCylVqzOYMAexAUA2OJraGxez1j92zfE0FkCEs7UpXSsNeqh/
Zr4IeF1lKxoXfITRPhkeApyg548O2TxewxVIGkrsJTSoCLhihCs9kkZtl0+v/IbZ
htnnVEK7fehYVSzbNTl8UNaorthZye/sc9pGmYyZrvsd8yzZxf1lGAx3uHCNCYPh
/BnuktjV1dd4pRMfWv+z9EBNHcZ2+QbsA3oBnmmRDq4CGJ5J7rHllL+FrcF1U+VH
RS5XhafZhoEQurZsFskzc1xNGGBnRsevAKrQUBGWmwexGPKEqdXt1F06iF83jeSB
qOtT3DQTRQK0xVmCz4jrhZYzlXaPQVvjY9TTYyS4htBXVkJFzUjqcNX/OfIDU+rU
LAyrY4ATyI/AWSWVq5EdVGBuAWkK07hPIS2zC7D4nbs5Z0QwFU9k0umjjC2oSdOq
zFcMN38o5m3Lzyl6lhAR+qBzCq5QR6BhUMIAeXTQ1Xb65cc6qDcb7VZURvQdD7mj
45QN6hxuLEgx0UxDQWAs
=Q04x
-----END PGP SIGNATURE-----

--KVy3XSgRgEDVTe6j--
