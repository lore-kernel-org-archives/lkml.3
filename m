Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3FGQwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:52:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52583 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3FGQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:52:46 -0400
Date: Fri, 7 Jun 2013 17:52:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org
Message-ID: <20130607165227.GZ31367@sirena.org.uk>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <1370621488-18130-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zqQqHHTowamqwYc0"
Content-Disposition: inline
In-Reply-To: <1370621488-18130-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/10] regulator: ab8500-ext: Provide a set_voltage
 call-back operation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zqQqHHTowamqwYc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 05:11:25PM +0100, Lee Jones wrote:
> When registering regulators which have a single voltage through Device
> Tree, the framework insists that the specified voltage is actually set.
> Well in order to do that we need to provide this call-back, where we
> check that the value is sane and return without error. Not that the
> selector isn't populated, but in our case list_voltage doesn't actually
> use it, so we're good.

Applied, thanks.

--zqQqHHTowamqwYc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsg/IAAoJELSic+t+oim9vHgQAJ1M1ZSJyKukm/+t/AMrfDRt
Kc1Q/N9mLyJkWBV1jaH3fzVb+B29lnO4c3pwNO+LzaxADndYlQCmJtIiYJShg847
UYFyihYXEegkxlhnHv8Z2F/5i/MLSNzV2O/42oaLCLAm7CLd8lL3ck5edotxcJ6L
AkivE+LGIF9BGcaPBE+//0pztKipIU/cyL/gmva7rOAtfXQLd/duCMAe3eXkRJmb
IXcMcfYSMTgU+69GoqzE23daiIbiWeqHscewnrBwwo0DibjhWTaNmYurz649x+ZN
A5YecdTgzaxmgFX2QyeNrFHM8HRBlPRfhYMV1rp4HzJ1sv9PvAsuzxZsXEYMmpgN
l7FsKzIytGpFPDLIc6w3Fdr4463mMmCREp5jNNWjAUym3w7C+IcN6yLkbt85zqLZ
azFrCL0YRkx7zRWruzRn/3kzBbXycuqXDj/yEu1Ui8Luo4YN6PcxdnuripyJU2c6
djfjChGno8e7lZrvYgIIESfu7PdxZ//Guft8Vm6ji5M0/9QV6JKP4CSuYVyxfzBV
EsMA6fSyxu0EOh/am3f8gvQcNSH5RL8MBdRDFx818yYR7OQ1brYoH/shDmeNbGnB
xice+Z+KzbdDL62wSC9mjW5wxU/WbIzGJafq/ZTgAPrt1jSdQLknShimXeEbDL1/
fiY5FbbGQmW9d7MWksdd
=6bYD
-----END PGP SIGNATURE-----

--zqQqHHTowamqwYc0--
