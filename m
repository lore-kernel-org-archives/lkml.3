Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3KASIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:08:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46657 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3KASIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:08:40 -0400
Date: Fri, 1 Nov 2013 11:07:52 -0700
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: akpm@linux-foundation.org, joe@perches.com, nsekhar@ti.com,
        khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        dan.j.williams@intel.com, vinod.koul@intel.com, m.chehab@samsung.com,
        hjk@hansjkoch.de, gregkh@linuxfoundation.org, perex@perex.cz,
        tiwai@suse.de, lgirdwood@gmail.com, rmk+kernel@arm.linux.org.uk,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20131101180752.GA2493@sirena.org.uk>
References: <cover.1383306365.git.b42378@freescale.com>
 <8bd26b17552315f0a3ea63c166a97a938c88dcf0.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5LK7OEqpP/xdrAG9"
Content-Disposition: inline
In-Reply-To: <8bd26b17552315f0a3ea63c166a97a938c88dcf0.1383306365.git.b42378@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH][RESEND 7/8] ASoC: davinci: use gen_pool_dma_alloc() in
 davinci-pcm.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5LK7OEqpP/xdrAG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2013 at 07:48:20PM +0800, Nicolin Chen wrote:
> Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Acked-by: Mark Brown <broonie@linaro.org>

--5LK7OEqpP/xdrAG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSc+31AAoJELSic+t+oim9HQcP/17w98BBi7pQE/a20dgRpCgZ
c+Qni+Mh2n5hOtsJwChvnOiSuhJ110Ca6g72KEMwB+gMHsJTBnRLxTit6mm9NqLm
M52dqcZe0Ze0Q76zV3S4PFxVJYw59YuCAG0BtPrxlZH2zt9y74/l3c9BSBKktXKL
nirgQhvY0aiTiUSnqofr4VKoAnxHNUlbxVBD7zVWwIDHnb8y7qpjB+87L52KY19L
4pbxK6jYubQFCnHh6/h8idf1DUNe6/NOyC8GpLOvLE6YUpFSzRjvUc58sxtNWVIY
fynbQt/VSZBa2Y6FV+1rk95Z3CQSyW6cBBolOFO8vNG+oOi2ppmWM1nmCkS5txs0
enmKl01e8v+bnmd9hYKIB/vW6crBr0EjA+8NlS1xcmiTovnmWtAICBfqhDumP2pQ
tLbDlFkCK/uRaWX/rhbMY5xPXzf4qOhq4E5+4W62+MgS8Y0hy6eZNQAFYnNgQgdj
T+5RaNKw9Ypc5C1XG9l8ygQXc5xD/9DxvLvTQSTh+XhXjeOfrqrgjzyoJtKwEcEA
A3miyeVqvkrvIcnC/MHxmhGZddwzk/m47zpIXnVJgTcb9tQgDxubxdamlaJXTgxz
5wstJ9EEknCJSoBS2PA1kEm4YH+1BoYW++bKr2wL6CnMh0ModKcoCEKeCqb+lYch
N6a2Efm/vEWRCEXNF2BI
=dC0e
-----END PGP SIGNATURE-----

--5LK7OEqpP/xdrAG9--
