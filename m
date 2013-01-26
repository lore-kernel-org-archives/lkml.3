Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3AZIT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 03:19:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54333 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab3AZIT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 03:19:57 -0500
Date: Sat, 26 Jan 2013 15:56:43 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps80031: Use IS_ERR to check return value of
 regulator_register()
Message-ID: <20130126075641.GA30594@opensource.wolfsonmicro.com>
References: <1359120581.12504.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <1359120581.12504.2.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 09:29:41PM +0800, Axel Lin wrote:
> regulator_register() does not return NULL, it returns ERR_PTR on error.

Applied, thanks.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA4wyAAoJELSic+t+oim9/zYP/1RWjN59KoG0ceIh0fA355rd
KUrj34o6/KHEb/TAFx9mtm5JHQd5bFpJxJh+JyEQOSRMRMIrTsrpOAlWSJDoQBOe
qZMMkLc2UwLT2THpBeZ92RpKBCTo+Qyoo4rWqyIku5dOq0E8l2Nosimq5GQ+fm68
Jcgu5ZoK4sLNN/tpqT3R4FRvSl7V/aRbLKZ1jpaDXXG8tcZtKbd6qfaVFAcYFx51
FVWPRkNso6Df/dsvD8PicBgMWVyyyfWpSa0erhx63DAsdyVHJLdOXKfGY5DMb3JI
vLNRU/dpXaSIPKf4jBrmTlDmMzUF/Am2eVBowMnnOX4mvI38B8lQnW/SXoDx29Sr
y7twR5av8YNOSoA9G4QAf88yJ8TnAMTHQuh/IwJyIC6cobOn1DCeuaMgo+qVR40u
6ViFMeUXyuPaAGdtRmRhE9gqmF2LahDvExbK73NPudwiC6P7iofFw0CKGXEEa6n+
SzMbCuWNskkwsLxA/TrQmj0WsehYYNcxWZ2GHvpl8RqG5qpcX44m4lVF39b8P444
s6uNXld5/OyiSHP47bAYB4W43jhKS5ZxsZza/HGC1nA11OGXa3RRMNWIjWJwl8a2
H/OD9yIrhU4R6w0QDdMpLSBG9hMquBoe7N0dHVC80/ZCnO7cH9YBZI80+P1Vyoqk
K3IrJjC6lj0b+AHMKjQe
=0i/L
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
