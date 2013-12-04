Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3LDJtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:49:13 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48167 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3LDJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:49:10 -0500
Date: Wed, 4 Dec 2013 10:48:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] regulator: tps6586x: add and use correct voltage
 table
Message-ID: <20131204094809.GR19943@ulmo.nvidia.com>
References: <cover.1386108712.git.stefan@agner.ch>
 <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EguBBKnZWdUQS9Kz"
Content-Disposition: inline
In-Reply-To: <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EguBBKnZWdUQS9Kz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 11:18:47PM +0100, Stefan Agner wrote:
[...]
> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
[...]
> +	/* Search version specific table first */
> +	if (table) {
> +		for (i = 0; i < num; i++) {
> +			ri = &table[i];
> +			if (ri->desc.id == id)
> +				return ri;
> +		}
> +	}

Ah... there you go. Looks good:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--EguBBKnZWdUQS9Kz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnvpZAAoJEN0jrNd/PrOhI3MP/iCQEYBVNh2NsQ1FNFlSgJnV
dXXQQLBqIxMDp+ExE356aNANGWRoWPIBkDzEp/IMA2pM1nHQyu3XKjUe7aXNdd8f
kxuUMiXnc/V/fx+p6Qsdb6EoF7qPQTQ+HLglVblhK7SiQCktifcoo+LmCFt/ZH0a
Tw4WAFYES2qmt25YedF22eShIplXBXXGCjRgYAq4FdDKY0HLHFVnxpFmYNJg1XPJ
qf2b4trMNOG/TwcaR2CLCho7TEgTVKPAWZdvnycc5QwO7xBoGclZTWzHcizKHNmI
jAu5eEXvkztUGfKZenRIFfGcgys3TEQ4FrTWDOQa2r51sbLvYN5eCa8h3oM+Fy6C
DJGfGykJyVE5nimkDKnykQdwkLr+kAMZH1E3Oj/BqDg9+27VZ53dXOEmi312wapL
4VyC/RbLiz6wZNfEvXpajtd60eS0EgLaySjSGTYCUbpjFDe9fhmiTs+e6kHWnD8t
HeFC1x49DBL7JupYH0cYA46t3xJUpGsmByogoHllJdAk7LzKuPCYq38myO/ngIu8
mcpuZmx0B9w9DBKQhYVJwKAflaVR6lL29CZq8/pIWqgxr4gGI5KQCp6D20rHZ5g9
JtR+pc/EQCu+0GeEatJ3cYF4/PX8NMeDoI8n2/uwKU+vftZ1O93NUaAPeULWFzR2
rfOTldJFLk7ibpkK9ojA
=oAlW
-----END PGP SIGNATURE-----

--EguBBKnZWdUQS9Kz--
