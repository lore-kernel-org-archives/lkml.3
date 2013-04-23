Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3DWKmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:42:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37217 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848Ab3DWKl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:41:56 -0400
Date: Tue, 23 Apr 2013 11:41:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Convert to use
 regulator_map_voltage_ascend
Message-ID: <20130423104154.GI5019@opensource.wolfsonmicro.com>
References: <1366428913.17937.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EdRE1UL8d3mMOE6m"
Content-Disposition: inline
In-Reply-To: <1366428913.17937.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EdRE1UL8d3mMOE6m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 20, 2013 at 11:35:13AM +0800, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Thus use regulator_map_voltage_ascend is more efficient than the default
> regulator_map_voltage_iterate.

Applied, thanks.

--EdRE1UL8d3mMOE6m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdmVrAAoJELSic+t+oim9OHMP/itQCkDCvTlbEBrp9CKNyI2G
EsoeZMPB4Jawb3wvEwmG1/VIP4OYkXFHaD9kYdTZ8ZdxaVNb4qbA9fyJMYxe06JN
g1/OQow11vsYEmUPoO1RPjWey2RYMXwU3dFBisZp2/NY43/OR48TjdeH5lsPH/XI
UbTc/vr9I2fiDyXf2CqWUXI0AWGNduSb8a/n/foxYyXnYb8eCnBM59scQxQVAtz6
pOcNJXr0XiA68qyvpGpAZ5GFddQX3PtaGES0wC6aq+5AZSRKSklNlaHueTRqjdOY
qI/ubT2en0jGTIjcB0PicseDKvcEh7EAFKts32gxRiYZXythANrYooVMPGXHhzUo
M5uVJu98l1MCmYY2OqD93uynyPTQa9uKPxwGFEeuyw/7/XV53M7jZzpR1d3WsqR8
PE6rdy5EGTSBr+LKAg1dKwZOf7I0s24wPVZ1PgPD+FO5laoBnESs6Kp9n/R3ZFHH
iQRHkRmr+X0T0USCgk6eP4BTB8wcaTRByvkiR4PY85XeYmNf3T6JLgB+Qd7zXyNA
4ZUWOmfAe1onMipvbXVL9mdNI3/sj/+yZyBb9/Ph0VTgOqfYlEaiOFuCPVonIoXQ
uz35ypNypv0SfS6G2bzH3LFj4nHyMt0Vi26lBdkt2N9NhzJxwW+B+f8grPbrX/jf
6FOUAVodSSPdz2dxrbCU
=uzH8
-----END PGP SIGNATURE-----

--EdRE1UL8d3mMOE6m--
