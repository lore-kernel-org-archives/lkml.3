Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaBRCet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:34:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39903 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBRCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:34:48 -0500
Date: Tue, 18 Feb 2014 11:02:56 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020256.GF2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-7-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZilngB4jitXEoqOO"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-7-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/9] regulator: max8998: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZilngB4jitXEoqOO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:35PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--ZilngB4jitXEoqOO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr9NAAoJELSic+t+oim9vhkP/RZnVopH1inErK/5NS8CFv4/
Q754k3lUTy+tzgLKetehW41UavoZZYQOiLMAX7oZCDFEDSiZHY6MgK6z0xYjITSA
CaRpzH4/IUd0+mQ1763tDkVlkWCfM+ayZDFjsQ6ZwXCfp4sCNHQkkxwed06rnG0m
1T2YbwzN+EphP3NQ15NyRBE74SlwGIOFh4ev7lWyNeaj1Re2vdbxRcVtAY2BZ3Fw
0AesLy8KhZan+jrkKbEio6Ic/VRuP40TVDDbPW81ddjJPyV9OlKlri3vgcVRwMoH
AfCuyYM1ttcNMI2yuPZ2rvu2NCQCptyt+Phwm/IGtXd1ytLaIjhmvJbacQ4puLpm
Tq5HlZxaeRsWkeP7M3fL4XKm2U+lfUMgcBlK5ydrOZVntJdvZSR2/nqoX5kqhhne
ZHjjAY+T8uGpKRXZv+aiPtEnT9AbcR4lbPGYHIWMBLHAMio/CPqathJnq8O+8jfV
L/HWUP1NVRv/LmdU0UQeU/PgbmaXvPkABLtdmqF4Abp1itS205He24qyzNCnmWYG
U2pNGY12h+mU3nSoCGGPz8WLagN6jCgzptn35g94HrO05sAWJkjEelJW+RbOqUwg
4Fc67jW3MkzkLr/YvsBPLJs5lW5HmQoSjKHVILg/TRXdVGCda/Tjjwr1i4lQ6FqY
m3MJ5oYfHXa+udFM9LjZ
=Ffav
-----END PGP SIGNATURE-----

--ZilngB4jitXEoqOO--
