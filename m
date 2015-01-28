Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbbA2BZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38389 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbbA2BZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:21 -0500
Date: Wed, 28 Jan 2015 19:40:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128194048.GK21293@sirena.org.uk>
References: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422447834-23116-15-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JqPwA6/cWC5gSNSn"
Content-Disposition: inline
In-Reply-To: <1422447834-23116-15-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 14/15] spi/xilinx: Check number of slaves range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JqPwA6/cWC5gSNSn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 01:23:53PM +0100, Ricardo Ribalda Delgado wrote:

> +#define MAX_CS			32
> +

This really ought to be namespaced.

--JqPwA6/cWC5gSNSn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTs/AAoJECTWi3JdVIfQ8gAIAIWnKfxiBl8ljTAgeu9JluoN
RYzLdcHKtSF923PvHoKy0Pw+Zw4d0oUj3l9QMcLVkuy1Lp/rT0ihPp180S08ms6D
epBsCMhJDVabS/iFZi+v3YPP8Lb6i5YkMLRT3ecAEyUil2mmfd0jPyy9EhACryo1
n5HV8ek7bPrsl2ZcFF38MKdsGoYvovF4aVirXi2OzTKW9zXbcOZg58Y0VSDf3dpp
QdzDvZqRN5LZ5KhQqEVTMv5GQgdhYQshlmiiclYMuOsfX5y1Ui5Z5P3YvNukkoQb
ta3mRsedQKzcrAVj1oQ/PVtRsfQBPsMLllAMx64q/b5IWHcTShqXkW8uMbMyAHA=
=vhaD
-----END PGP SIGNATURE-----

--JqPwA6/cWC5gSNSn--
