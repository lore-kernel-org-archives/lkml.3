Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaBRCA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:00:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58350 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbaBRCAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:00:25 -0500
Date: Tue, 18 Feb 2014 11:00:10 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020010.GB2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Y5y2FX8vnqwSxRu"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-3-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/9] regulator: da9063: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5Y5y2FX8vnqwSxRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:31PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--5Y5y2FX8vnqwSxRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr6nAAoJELSic+t+oim9iccP/3t3dJqkiwtWXeVEJ4mpk6LU
MhI0wrMBrw9PUZQ++GIED6YL9Q0ULYrB8DKGzoHZ9Vqa5L4nNzg4s9ti3ySjZ74W
GAQWq8nwrWdho7G0WCsX2ECe9YdOVQ8yt4vkwOn285qgggZ8+DKEVqyR2FFcltNZ
oG9ZKzfgLqX92T7MHLWLuqBSgMKQpiAgo5MJq1E9cJ8Xkmek6FtMt5AiBtvTTKPP
Z3/OlYlnFY8pzPlxs53Zx+1d0fH/S4MaOve1PA7x1yIhE0lEwjaStgeMAN9KBITg
oA7VriKV5EtZpoJeodDeG+1rA/NRtLsYjz2RDrNXPJ+2ncpU0BCtpLVnA0oHEWTC
zj7hlj49Jk6AgUWMSQfgq2CIUFKqOofi/Orgm7kiq+6ozKE4zavWwTWyOHA/daRk
pugCMi4Y25ScFT6CM4cRzG9zewduEe8YUwDW37vQpWpvV0HonuT0cJvn1idxMeSG
hv3Twt1zOnNLlyzWss1odf2VlUHALcAn1clqbP78qVmXhN9uoOSuhhCcTnFeDNlc
yUYB2+zfi6fjwjFNwzuSOb9YvCmmZDUnVV9n7qeFo+lOWyF1wp0873/MwvIJKYj/
ll7nXX5ZAJP7hixnK8e/yVGK2XIiEROoI2fPsfhYnALQkFzFVErZkHAgNnOT14+2
8XRlAynICZrScBu1kEfv
=urdA
-----END PGP SIGNATURE-----

--5Y5y2FX8vnqwSxRu--
