Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3GBSOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:14:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37204 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3GBSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:14:14 -0400
Date: Tue, 2 Jul 2013 19:13:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130702181331.GU27646@sirena.org.uk>
References: <CAPgLHd-VN4BiM=cEkFF4EgbL7iqR1XrhEzBiKyoJBVnzKspHJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Bm0M7I+ZJ5WKh7s"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-VN4BiM=cEkFF4EgbL7iqR1XrhEzBiKyoJBVnzKspHJg@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: brownstone: add .owner to struct snd_soc_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7Bm0M7I+ZJ5WKh7s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 05:26:21PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Add missing .owner of struct snd_soc_card. This prevents the
> module from being removed from underneath its users.

Applied, thanks.

--7Bm0M7I+ZJ5WKh7s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0xhIAAoJELSic+t+oim90TQP/3t1NZvLnMQn0HXkttqbQ8qr
viErAc+/cLzqsU1Q77C8Vg2O3FZpOEhc15ru7E0pGi22LkDD9iqacypPYBvGOkys
7tlelniz+xpZywTVnaMS44NZ04tiMKIAhpXcA6N7l2ZBY3hBKmDtg2i/a6vVFswH
oldyoDDaXKHJ1EqlI/p3VYLUb7WXaKAFNp8bBLc1Cof9dxk5S8rdTQxAAohCRTw5
tHEGgW6+GkQfXEww1GUEKpvrkaLS9h1MY9KiASUUygpPpCYCHKQXcveWYh0bHR3O
r4MrzOFDQ2uTefwC7K+RvVmnCtM/zL811lZtJSwQ+MQSDW/OPy+3e8sIBUE6Fmu0
BzjDAQlYN3jmXy6dpKdZFsxZN3zdL2OSIq6oXCXlsnkmgyNc7AzcNHoXaqMz8XwG
olxInVU6Ihi9JaG2PfW3xgnrm70tUt0/Ssl/AhFoYpVqe8iGCplWmgWUvSdFrHMf
63HF/qK7dA6LWeGSsDwVrIpVLlFbjF4NzSSBNvTdfX21lBhuxXQMpobwaXc1hrBL
xKiuVV9Ndm+7YxiFj1K5CG8FmrxMRAfwptDW0FqWmmcl71qygPRjdsuBcMqnB/fD
e0bcRcasWHiywrWKYpWFSJERAVzpNJTx6LJEvhcoJk86ldETN3CzcAfL0e7DlLng
qs76lDhmDgU4fuughvtk
=YRCW
-----END PGP SIGNATURE-----

--7Bm0M7I+ZJ5WKh7s--
