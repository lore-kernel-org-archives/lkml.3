Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab3CHJp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:45:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454Ab3CHJp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:45:26 -0500
Date: Fri, 8 Mar 2013 17:44:46 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        mturquette@linaro.org, linus.walleij@linaro.org, cooloney@gmail.com,
        rpurdie@rpsys.net, sameo@linux.intel.com, wim@iguana.be,
        lgirdwood@gmail.com, gg@slimlogic.co.uk, j-keerthy@ti.com,
        ldewangan@nvidia.com, t-kristo@ti.com
Subject: Re: [PATCH v8 04/12] regulator: palmas correct dt parsing
Message-ID: <20130308094443.GD28481@opensource.wolfsonmicro.com>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
 <1362662276-20792-4-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <1362662276-20792-4-git-send-email-ian@slimlogic.co.uk>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2013 at 01:17:48PM +0000, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>=20
> Fix the DT parsing to agree with the bindings document. Some small changes
> to the value names and also fix the handling of boolean values. They were
> previously using prop =3D 1/0, now just use of_property_read_bool calls.

Applied, thanks.

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRObClAAoJELSic+t+oim9yp4P/2u+oc0znK+IyLsewOE83Iap
VP5ijx7aXMWbYMdYKu3d6AWx9wZDxTEpp7XMK716ot5/Dgngu2Pq53ubxyQIvO0U
Z+AXJHH2z9q4RKjk0ov+rlhPK+LjjQY/zztrGTQul4pvhWW45GDnR3fQ2aCDRyMP
TZ0OViwlHGqVSkaZq0+v4aQFqkLr5jvbALe52+C7dQ6JwOAJk0Pq+LxwsrpbCmMT
9/fxsMfbSaoROUzQwLTG6L35eMLFYWaBT8ZKq8QugNiOwVCz2lKYsAKyZo4qi+R+
Zxo76aCFp6J3zzoUdWofe6IcaPiHBhBlRoBmRL5V+bV3V6HsbTwwI7NOdX0AVWLC
g/BqEspivOusSiAyq3S7Rs/U+MZiWoGkLQ+WAejsYNTnSPlPXHwvRsc7tdDuy5k+
ptLun5sXwG7rh8tV4DMTFSQ2f8S2ZrNVD2HCfZItJxhHHWVAk5USshJgrANNd+8y
nMqSzZWhHT7AIF+1Bjpq5GlFtMGMwbSEdwhm74DeSqX71TkZFaWtBUinbGo1eNWb
6ZIsigrFGJS0XTvTxjuPWjRvERL2XzwO0b+Zl1O8n5L7zgQmYYagU2rCUAM+nrB9
YFg60AG81tZHz8FABlJspxlSbl13d9pY3KhEKYagJ+CXUnANpD68kt0q9OE/2e6B
cGhJKaf3soS1JyAVFydM
=WT8H
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
