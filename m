Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3GBSPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:15:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37265 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3GBSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:15:15 -0400
Date: Tue, 2 Jul 2013 19:15:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, wfp5p@virginia.edu,
        yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130702181509.GX27646@sirena.org.uk>
References: <CAPgLHd9kdRD1fJZZWLN+=0ddsb3ZxjovA3OU4Ctrbvj_b3Jw3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B3UyBIKcLn4zZXdv"
Content-Disposition: inline
In-Reply-To: <CAPgLHd9kdRD1fJZZWLN+=0ddsb3ZxjovA3OU4Ctrbvj_b3Jw3A@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: db1200: add .owner to struct snd_soc_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B3UyBIKcLn4zZXdv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 05:19:25PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add missing .owner of struct snd_soc_card. This prevents the
> module from being removed from underneath its users.

Applied, thanks.

--B3UyBIKcLn4zZXdv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0xiqAAoJELSic+t+oim9iNMQAJFVNf5ahAWjE9VZb3eBcBmS
OegQLnJUGU3XxokKl1CtHA3LtC8vkb89ZOYRDqLYvkAIvDxHE2UCLCnWez7ILsug
KvmKe3mfjZwKw11PErbKo0JRS9WLfT+85vJq4vS5I4P5D4kp/8q9FX8LN2dqdr1q
AAzJX+GfwCqWRe/yCWHXyg03R1A+0UC+aQHWrFp6IsD9XyrCYVtoSAeKikqpNzf1
B8JDEqO4l086MYUAi5A8HrPmQFRDsRunWJFF2IMxIjJ47Qqz/7In0T+tZzE3FJhO
f3b+K6LCv892j30816ehbYjQwVBu7xy+AP6l6UM9JGUoHn74Zqla0WmecE9nK5sa
oZkp/a5gOzGqw0rPAeDz5kX/HTzdE9kACbvkMvn9Owch5wANn/jdhRN5VclwzJfZ
3TGOvLzPGNFBCkpYCsE3gxdIPXPsK0DPJCmEVn7jzgyyiF5854dym6gpuai2R60u
a7OANkjLhr/6jVQ0oqvOzn/wrh3LUZYMvfhkMSuLYmiubTdIbtEBvE+pUG+nWl6L
PLpjT9vz81E9x72pJmI2rdZKs42sDNjDVM0qgt3fj/k1sfQtz6nycMWQD0/LKlsq
G6NcrdyI6DVZpOUcomfZZ9pyHpNXdjFyTyd20R1RTzsUvQRVcPl+TxLMK64xRv9Q
miXxO3bpmTawGm4V+ekR
=g4YW
-----END PGP SIGNATURE-----

--B3UyBIKcLn4zZXdv--
