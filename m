Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494Ab3BNQq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:46:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46154 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab3BNQqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:46:55 -0500
Date: Thu, 14 Feb 2013 16:46:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: mmio: add register clock support
Message-ID: <20130214164651.GS13249@opensource.wolfsonmicro.com>
References: <1360859948-22473-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLfVvEQOBD/VeTNx"
Content-Disposition: inline
In-Reply-To: <1360859948-22473-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLfVvEQOBD/VeTNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 05:39:08PM +0100, Philipp Zabel wrote:
> Some mmio devices have a dedicated interface clock that needs
> to be enabled to access their registers. This patch optionally
> enables a clock before accessing registers in the regmap_bus
> callbacks.

Applied, thanks.

--yLfVvEQOBD/VeTNx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHROZAAoJELSic+t+oim9xz8P/1g+Kk1++mYaFk+ihE5O7f+l
+gfOcNf6QSS26HyDi/8drsUh0ukIvCyrirzypeGUS/Wke8x2PnQPHEH49bLECOvU
FwyJtLhJvrGidVS5gSw144Dt/K6Nnnr0mrLGfBcvpbGzVyDT1geJ9oE+SgBlw3LU
9aTKNCrj/kIErY04d8eIfGARbqGdFb9bp5bqIYx2oGSPYNtP5qM0ubo0Mx2ykSop
JbBindDf0ni410JQoDxQ1F2CwVxnFmPYGidpXHMvLYWVF5sF1VrauSNKRU14h3Gq
M2A8S/UZ6qZn39goKpCbslD50lUVeARuUbWySEBlx8Z95uZMEdOnSuLY/j3hsFvZ
rscuraT9omfY+Z4HaL+yAj7TVMPpsn6Mdvke/ieD0WjR2a7e2/Lk4Q9kKGF4IL5h
LQek8xPc0nh1Px0Yp3epzjQsd8zapgCasrf/ySy57dd7Otf3qiUJWUAUmlC4aru+
Oxde9sNl/A7ch+qODmcZ5zLwxw8VXw4qwnPWQalldbcKhkMRX5oAuM9424/7eePd
rHcKVD/bjnlhl7AfQihEKhD2OF0zG2gtMCY6HrF1CDEnMPeLs0L6Tf0z+dZ6be00
dxQNYKssyVcU+4dFaqllbo4kGnhRRB3NQSYMqqA/UMnq1JDPsjEmXuLImeYeFIqW
J20PrNMdTGnI9YDACGvk
=kU5m
-----END PGP SIGNATURE-----

--yLfVvEQOBD/VeTNx--
