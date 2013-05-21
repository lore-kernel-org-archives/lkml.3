Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3EUR1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:27:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45906 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3EUR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:27:07 -0400
Date: Tue, 21 May 2013 11:35:52 -0500
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130521163552.GC1627@sirena.org.uk>
References: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
 <1369130649-15179-2-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SHFFXbs3XlGSDX14"
Content-Disposition: inline
In-Reply-To: <1369130649-15179-2-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: ab8500-codec: Set tx dai slots from tx_mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SHFFXbs3XlGSDX14
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 21, 2013 at 12:04:08PM +0200, Fabio Baltieri wrote:
> Replace hard-coded tx slot numbers from ab8500_codec_set_dai_tdm_slot
> using the ones requested by the machine driver in tx_mask instead.

Applied, thanks.

--SHFFXbs3XlGSDX14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRm6JlAAoJELSic+t+oim9oNkP/A2lyDSGHEufNt2CJZDV2MdF
mWqjFZqV+QgLypabL8b2yIBb3wDuothipW2qLX1PnEXedEltnEQ0H5865LTu1+1q
Dx9JSNa/w6WnzAWtNKCLOq04hBZGrKf61SpSXxfHPPPcbqb8N3T1uWGPSZzMj797
GqCJ8j+l6YhXyTe6PnAMhL6pgw0f2v1mkwb+wewJ46O81GyHaloyK3yxgmH0SSND
qUFuYJWodk5xWrMM7Ssnf0L37skpfhmLUHK/2I25QGu8RCZVMPvKrt8cPgX9wsAk
GTE+/37oWaD+2FdJgce4lcDbYjj3hYroQf/8YL0TTOaeBTYegFI/kGo9ROPOE2Mj
LR0GXrn92gqlpTYN8hr4wnZKpSUWAs4Abq0QPzcnDfGJsiYeFe11yP/vW37pJJhD
nAHd2cC/Zhg0M3I02+hHx486DusLch7EJsZq9v48GnCH/40yLY5dBTNYgSDx9+qD
jBOFgAYy7iZ9yD16sOC/bQw5/pn31WIWcvVLKHqPMUcim0w92SUUyL+WGYJOT0f/
kaGl1UpPB+qOlFkEN/61q4y8Lli9tPsTkHZWfwuB8nid4LNSw4xd0CoLAGvLqKoN
9pC/qIhdln6FlbEDh+y9xxJG2tCwwPY4Q5ctVCPojf5Q7V0RexZQ0FH5wP/pA2wb
LfdPZVH+L+fyj2ng6OqQ
=pfF3
-----END PGP SIGNATURE-----

--SHFFXbs3XlGSDX14--
