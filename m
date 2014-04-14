Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaDNUjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:39:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32971 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaDNUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:39:12 -0400
Date: Mon, 14 Apr 2014 21:38:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, rob@landley.net, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Message-ID: <20140414203851.GD25182@sirena.org.uk>
References: <cover.1396432924.git.Guangyu.Chen@freescale.com>
 <d09da3eb629143abd3f61ae037af4ddaf7286a83.1396432924.git.Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bwMunqOr7B7rzQrh"
Content-Disposition: inline
In-Reply-To: <d09da3eb629143abd3f61ae037af4ddaf7286a83.1396432924.git.Guangyu.Chen@freescale.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ARM: dts: Append clock bindings for sai2 on VF610
 platform
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bwMunqOr7B7rzQrh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 06:10:20PM +0800, Nicolin Chen wrote:
> Since we added fours clock to the DT binding, we should update the current
> SAI dts/dtsi so as not to break their functions.

This doesn't apply against v3.15-rc1, can you please check and resend?

--bwMunqOr7B7rzQrh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTEdYAAoJELSic+t+oim909YP/1fePSP/VU6q5ZG2V6LA+Ien
nDePfbzPoLOsJA05Wg8OFj1xKg5TLpnk7ZAqRr/kg4dLxp8QdEO1LlpR9f/YNBdw
5NKYyQDCGNf6x0Qglbr8v2vrXlrV7CeWIeZ2PLE3S2O/0YZUXWGw7vy6mz/aNjFL
DqyNM/MQft/FNHN+A4odSGRT+zQkDM6chtAqCQa7/Xw0y4F9OsbWQCRXb4Q+KxL1
bYwoc2xHonhUgZD01M0k80SXGcXfiAYDfx5a5l5u7+K3hz0HVGudsHclaSI/cy4T
PUGi3sZ9i+oLwdmrYtNPAmmllcY60+VTbdWdK2EJrE9MUpaCUOhtvoqqcQ1WD7iC
iWaDJ8CCer4rHo090cPQwejlnb62VVeLsZrjKyZXMT/XupxnJQo7Nbhs7gSbUwWb
mi6q+A/+DvyaMhZMbKRdjQhoED6xoQjArirWLmKiNPH95FPKDAwMo+AyqYvPGJWy
5KAoMjDIaV7zrTlZSRGefgpBhKzCGQBxg+P2NSmantEX94rKW43kwQng5OlMRhV2
nSQ/x3Wj0xPZwxhfQS/KDaGpS32KSnj1lFCbwLRFuNciphzmXRHI2/4IeVoQzvvZ
yi+sATUjrrcshPU4qLdsp8h2GRiC6Uz06+hmCPElI2Bvby3xt5E4k2zv49KzlsqB
LMedOA0Rd2Lg6ygCIfYE
=3HvM
-----END PGP SIGNATURE-----

--bwMunqOr7B7rzQrh--
