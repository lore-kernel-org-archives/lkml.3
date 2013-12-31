Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3LaMtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:49:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3LaMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:49:51 -0500
Date: Tue, 31 Dec 2013 12:49:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, rob@landley.net, kuninori.morimoto.gx@renesas.com,
        fabio.estevam@freescale.com, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131231124945.GU31886@sirena.org.uk>
References: <1387776299-25418-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3e0+L7380OK+0MAI"
Content-Disposition: inline
In-Reply-To: <1387776299-25418-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Cleanup __asoc_simple_card_dai_init()
 ret check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3e0+L7380OK+0MAI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 23, 2013 at 01:24:59PM +0800, Xiubo Li wrote:
> The ret parameter is always equal to zero till here.

Applied, thanks.  This is on the edge of what's a good cleanup - it's
a taste thing if it's better to have every call be the same so the code
looks more regular or if it's better to have the redundant test removed.

--3e0+L7380OK+0MAI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwr1mAAoJELSic+t+oim94mwQAJ5EMf3L0wkX6idAIhmz3NyH
xmtYTuePJUizh/ylrk4/2qLpEF2Q/YoCEtPBXHiNEqjmKn+BD1aegMt1U8OoAwbb
20sOUnFvNcUl2xAWOymIzUh1I23rOeb9Sw8K9c4CuGGSyarjhLhS5q3qUyXK0nSM
3E/PcxtIqhfzm2uDmFJXBlaAZFNmb+iuAsnP0/WkYNgcNIk5ei1vYsUFIs+7X2J4
Rq8Y35Q7xMKrZ0sSS8Q58FwL8Z3GN1fCY0s+9ssYyu9d5RZ2WPwFvN3e4Iy8V8GD
PaPtSDm7deM8WeAAJlB7dQNiurgcI5pZz7QwiiUtBESMj9iv2jflJxGW+dFDwLSX
mSZzZpUyjmNK3X4lIbIc5bAmgLQVp3nbxF0VDEhkoi0IHU8I7LenI/TVOg7gFZY6
nHQ0HNhA/ZAVbvFrkX+p8xXe+phARbcqD4tON7pc+cZYVMphzEg/EibZl1jsbSUi
i/5AeOJZgf1bbr8V5VPC1dWKfAmANcd2N9HXuT97dBBT7f7pEVXIIZ96Ux8pUcQM
HQaPC8m9CGcIk7K0/H7p0aMP1cl1SWNd9P54YjsEpFQhLSTMTJIU5o4sygWYU8ur
24lFFuKV1vmCa/EvsPSGdGxFN1e6l9sckki8DtvPj7TW4r8rQrF8DH8dZUMZ5c+V
JxwRvtPltKtGu7jkFUCe
=TEwv
-----END PGP SIGNATURE-----

--3e0+L7380OK+0MAI--
