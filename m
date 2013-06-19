Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab3FSTha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:37:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51401 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3FSTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:37:29 -0400
Date: Wed, 19 Jun 2013 20:36:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Cc: tony@atomide.com, sameo@linux.intel.com, lgirdwood@gmail.com,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        t-kristo@ti.com, gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org
Message-ID: <20130619193652.GJ1403@sirena.org.uk>
References: <1371644642-934-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qRu+kOci6Aaql5G6"
Content-Disposition: inline
In-Reply-To: <1371644642-934-1-git-send-email-oleksandr.kozaruk@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] MFD: Change TWL6025 references to TWL6032
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qRu+kOci6Aaql5G6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 03:24:02PM +0300, Oleksandr Kozaruk wrote:

> There are non-mainline branches that use twl6032 by its name (for example
> git://git.omapzoom.org/kernel/omap.git). There is intention to add support
> of twl6032 device in mainline, but we'd like to know if we can use twl6032
> instead of twl6025 in our new patches, that we are going to provide.
> Related discussion: https://patchwork.kernel.org/patch/2686331/

It's always been OK to use the new name, the only question was if it was
better to keep the old name supported as well.  Given that the chips are
essentially nonexistant now your current approach seems sensible so

Reviwed-by: Mark Brown <broonie@linaro.org>

--qRu+kOci6Aaql5G6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwghRAAoJELSic+t+oim91rMQAJUAcSoRIh6J8WgAp3MuXH6I
wHaM1UWySf8ULxIdOorogkQ4oIRoK4Tb9bP9BnvN36X4SEG6l/A850Awvg+LX5k+
vQwEwzekW9BG/KgzYbz6172Nym9WjDQJx9mnCo0W/FCSSr4v95pZHyZsV6ZX64K5
wwkORVriKT00Tc2q7x++qFKw6oUKVCyfeFXLXbs+rTreZuwZk9hK+2ZigfKoetkw
GNQ1fI3O65eAmUtETPPmfNRnmVypF5Nll4UgcqpTNDrwZfQPvcVe/eq9MVLpp+f4
gl8zS2VpcSfMR0MY/9zgbiPYQPQSYDqiGQ14naEJOm8hUYGnxd8TB31TjoGIwXXm
TqhMfSKpDiWAUsCprcfym8ZC7CGm1B/JNABLg389t4B7MLesVGR/MfhxncSFHb3H
wnbsTUG08JAY6ejC5EkcHgHtNwxONptbRJt/YGrdqvExmCMAae+5Q5mY0SsnYDzv
2vox1lJzHr4Qu3Tqxain3i5LOCNBp+3Iwym5YfvqQc+H4XdWbCAscfc6/xl1YlU1
ihTbHoLBUps608p+gLPdfN0DTDm292DBrYSofR40Dl+8XnLAwBgIpO6rcttKiwI3
7lIsKwQ9gqDAA9sKFLgN1TM+mbQ47QFW6RykoYB5aczMEcUnPZjQMAlf9kX5qX46
1d2wtP4/y/vCUWiTyjYo
=lZSA
-----END PGP SIGNATURE-----

--qRu+kOci6Aaql5G6--
