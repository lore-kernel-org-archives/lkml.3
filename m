Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3IRQNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:13:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47922 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3IRQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:13:43 -0400
Date: Wed, 18 Sep 2013 17:13:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, rob.herring@calxeda.com, mark.rutland@arm.com,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130918161329.GC21013@sirena.org.uk>
References: <1379508482-10550-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hZM3YBJafcqGfHn"
Content-Disposition: inline
In-Reply-To: <1379508482-10550-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: core: add support for configuring turn-on
 time through constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+hZM3YBJafcqGfHn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 18, 2013 at 06:18:02PM +0530, Laxman Dewangan wrote:
> The turn-on time of the regulator depends on the regulator device's
> electrical characteristics. Sometimes regulator turn-on time also
> depends on the capacitive load on the given platform and it can be
> more than the datasheet value.

Applied, thanks.

--+hZM3YBJafcqGfHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOdElAAoJELSic+t+oim9A9AP/3sD+fGhZG0KxDf/qgGsHKMV
T5fEROdvqTo4IRNCY+TuLVeSKuuWbfhZaWNkU2NYca9XuAhPHZmB8vBkxV0IBV6O
AGAezW2L4f0kmveCc4PGdu/aNAiHawgOo1qjXySrt3A7BfXbXjOObDu4IydvQW+O
EEaKodWZw2YHg+PRq5QUyP2118QkSE4S8jA5COr3YOzLWi/X7iaSqPL+WLpZ37xm
hcXWXfAN3z9zFVj+ex5IBYgJaxQUTnVRRJVRW5b0GZl5/UQ7dJHra5okp4/EdXG5
sqXON/leCntc9Q8/wxLOdS7q67oeWuOvDs3UMNPJ/Ec2oRwO31JkWhh/H3E49cPf
FcFwALVhG24ml7gsO/BL6BhdNZICjRc7jgCCyCZALYuvtu1N4ho1I64ng28idZA9
kdwA7mbBJI2yBVQ+s1KQ9TSbjRiZiOAjRR5ac/UNnvKjMXqWb5edPJZVHzvlQgjs
3eRNr9ZKrvhtAvkeJcQVGwJXtKwrMghcqnu6rtSfBgYTx7QX5Qm9KzuWj2H0f6GS
FmZckkpz1Z0TV3CUsvkJ4USBfLCNKkVADYaGsIsHrdrhmiCK3qxT3EgP4qkRF84s
iJnk4CTGhROEjuFKNkjnBC5QK1rbfRWXzHRR9iSOxXwLAl5a20grSSE1DwGnTzWX
UYIOG7u+YbZoy8l0uQGu
=vLZP
-----END PGP SIGNATURE-----

--+hZM3YBJafcqGfHn--
