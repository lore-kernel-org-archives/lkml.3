Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764598AbbA2Dpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:45:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38397 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbbA2BZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:36 -0500
Date: Wed, 28 Jan 2015 19:52:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, agross@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20150128195225.GO21293@sirena.org.uk>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1422413199-17273-2-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hLSAHGZhjGZPYsTW"
Content-Disposition: inline
In-Reply-To: <1422413199-17273-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/9] regulator: core: Consolidate drms update handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hLSAHGZhjGZPYsTW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 06:46:31PM -0800, Bjorn Andersson wrote:
> Refactor drms_uA_update() slightly to allow regulator_set_optimum_mode()
> to utilize the same logic instead of duplicating it.

Applied, thanks.

--hLSAHGZhjGZPYsTW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyT34AAoJECTWi3JdVIfQLK0H/A/kaSHACGlJqtTPrFyykDQR
Ye7nDYpZ5N2rf9w6J6eDrOn/edWAvePj2nxoMMTFImJ1tLHWydScr8XhJXGCvDMP
vxcMkt1IobTh/yxMQT3I+Use6lVrDhASTi6U4SPl84470Y6h8AULFmUR/XorquON
t31tsIyTqk05cbq2qqQJz+bi9WjaRWol860ZmVJxpTxxsqBVv6K9rymColCUDPjV
DQ92f5Kp7ex8Yk2ieitDkQ60poUNPdlG2OELzGDNyVMmiWleAbSRq7aphT3GXNVz
kS830uqMNjw+P/i5qiZW09qsO0u/wzq4rbVZu0N31wRVu/8u1AuT8JVd8rsRWL4=
=dsB/
-----END PGP SIGNATURE-----

--hLSAHGZhjGZPYsTW--
