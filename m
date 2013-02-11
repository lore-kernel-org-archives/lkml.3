Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3BKRF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:05:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58316 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757640Ab3BKRF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:05:27 -0500
Date: Mon, 11 Feb 2013 17:05:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH V2] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Message-ID: <20130211170525.GK4607@opensource.wolfsonmicro.com>
References: <1360565374-1553-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
Content-Disposition: inline
In-Reply-To: <1360565374-1553-1-git-send-email-j-keerthy@ti.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 11, 2013 at 12:19:34PM +0530, J Keerthy wrote:

> The min and max values for regulators are getting assigned before actually
> the voltage is set. So making sure that min and max values are assigned
> only if the voltage is successfully set else keeping the last successfully
> set voltage's min and max values.

> This is boot tested on OMAP4430 and OMAP4460 boards.

This seems fine but doesn't apply against topic/core or -next, can you
please regenerate against topic/core and resend?

> V2: Fixed comment from Mark. Introduced local variables to hold current
> min and max values.

Don't include things like this in the changelog, include them after the
--- as covered in SubmittingPatches.

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGSTOAAoJELSic+t+oim9rZwQAJfAeRakCk18Qkni8yvvWS9r
FG07wtIsjY9iV09Nn2K6KrbYi07WmYr3zTuhDxKRjYicgqmM+dic8ik0coglyFMG
KhVp/1Lg/dNXG9aS3z0WU/8XkhdOwro5+bjrqAxPBfZMRFAHwrAe0GUbxbFn2TnX
AD/bWj5LLrXM0RKjEuScUn8HRlzgz043aVcSMGgJ74qF+6NBu78ro0k/6VGqcxP4
5RZ71r46G4crvEQr8L5bxJB8icOCH6XUKYiUU/8FQQ245Da3F3OctOX2oy7ZBb5M
1W4pWyjZ1zdU0pxYga9155v/z5HyBxnHiexcG2cgPYpngw20kMHo1llPu/pUoaAE
y2tcr/PH3obYqSFm99kD7yd3sbLndg97qmMV3EESEue5jdAI1WUYqB0xDBUc/PKL
lz4lq01j2VoOYlUfYqpAjXRraWVu9tX4MrFI/h11VLs1/4ya7ZGFLWzE83wez8VC
SWdRRJSQx292pNYdSKzczFd6URSFDpZ5kS+fvKjA9/EjbPoqBdicnDhGRkkZyFQS
S8M9yqWnnqc1O6PXJ2Idtz+DoXCPD2Z51sZQnVdDltQiL3DYb571C8WO0n+GN+yh
gtrFaMcYXWWm60lTLdClGrx1L8g+MRZHZElwG7oa7M1cArHUDZLbDpzhsf867PVX
DLrvHY/lKD2reQ/K1Rxv
=34v2
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
