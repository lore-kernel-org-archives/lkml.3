Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaJ1CSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 22:18:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:52863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaJ1CSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 22:18:42 -0400
Date: Tue, 28 Oct 2014 03:18:35 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 5/8] power: reset: at91-reset: use at91_ramc_shutdown
Message-ID: <20141028021834.GA5739@earth.universe>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1414451377-11053-6-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <1414451377-11053-6-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 12:09:34AM +0100, Alexandre Belloni wrote:
> Now that all SoCs are registering the atmel-sdramc driver, use the
> at91_ramc_shutdown() function to shutdown the sdram.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTvz6AAoJENju1/PIO/qaWdsP/AtuUzTI4Chfv/0N9kqOJt1O
gmTUimN+iImXKO03k4vF9lR49/anhgvIY8HfZlA76JQCGpDP30jaEiE4T4q+/DRS
1JA/oTmvZVUooy32zU7EO/ZOVaKEvCercGRlQHays5EDLGFkRIacsvL07St0zTZR
dpapnOX5Zr7Jmu94iQh09mYGoFUNSLfqThaVA0rV1I8W8+gPi1N57nZiR2MQp7HS
4F1ySzEu/5SD7hsJ/XhqIyeXZ0HBnj5UMJarVvCAc1JL2/bGaKAU8cYN7BJxm5pM
LLHkushn9zSJzFf3aJ+6UQ8O3HA8zEIiAra1AhucnzxmpYNW0l9VLHJVzFJS7LIT
HOKxhrCL3sHqtGsKKeVSjaK3MWFYHswwnpCTpccJ6ZVundBG2ywp5KxTOn/u9r7s
Z/cN1398KCE0efz2A4XrdtQg+g4gxb5cAZcUjoTrLA+MaGUXfyLohqpEnuT3eyAn
/8+gfVvBv8TYqIbq1AipfhGXhiFh0krGehMmb+AonY1HgW3wMWIwiJ+vdEIdnk4l
p1bHa/JGgyVB6hoFMtq3NOqIlxngUmSCGTa6Xl4NxeB9vbXjJILJ4IIonvaEwsUM
yrKaQkKTYmwbqAC84AqlawoRTWzHYN9NzQu7sFf/cjP+ZBF7gcfQv3q9I+R2kzEe
zacNqsCzdS8aKUANE1yB
=sckH
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
