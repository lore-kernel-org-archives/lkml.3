Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaAWTYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:24:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58697 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaAWTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:24:46 -0500
Date: Thu, 23 Jan 2014 19:24:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123192434.GE11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="idY8LE8SD6/8DnRI"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-5-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH Resend 4/8] ASoC: simple-card: Add snd_card's name
 parsing from DT node support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--idY8LE8SD6/8DnRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:46PM +0800, Xiubo Li wrote:

> +	/* parsing the card name from DT */
> +	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
> +

This is OK but new properties need documenting in the binding.

--idY8LE8SD6/8DnRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4WxvAAoJELSic+t+oim9BqEP/iB1aYHZXg3M9NDTXzT5q3Gx
DdGCJVIeXiDI0ztTYXg7vTSHfTAIY7SjL1UFhZCYkM2LxLojeNQ38WdU9rUSCeFQ
/n2cmovsvlivM/Ndn5A4HMwHqDkhyGxFHkn+SqWmuGcYU24jKMSg5Q401oJV0Q0o
bUje+e5rZnOtoX8w5Jsl8XJY5yovgcu835Hnup2X0e5lS6i1y9sDQHlnU1kKpebf
oHwE95HLgpUkrvS3OZlMDu2fhDnpFrqwhM1BJm9XAnJZWkrbhHTlJfOBEwWJqEPJ
9q+ZBtqfD/YnwY78dmRRak3sA5x45FMygtLsFejFEpSePGH92o6K0qTTjW0VzxQh
TYykC5Fa5B+Pkf1bXP+oYZMLDhqH+rd9U0kHpNLA0KEb+3zYW06j7OiCXw+X3scZ
YQNZjZW6cB38FKzWPr18AOhAZO1WCMRK/3WYtQkpT8TVVeF3mOR07F3Vyjnx0ykj
7GWYbHPRl1qZ0ZP7yl4T24n/S0b63t7gzvO8thMUBdw9gVq7zkaop2MZl7AIWcrl
aQnHznai9if88PtHO8isxNYTKr00bDetGFOF3XjHGD9Y+FXtIIW3Z5r498892D9T
xMHDuUTCDIVUkCrGXx60Ezi/6L7u9KzSs063lvShc8s00XumAPe0VaamvbBeqEko
eEmk/RLYE69tfVqmTilk
=bpuL
-----END PGP SIGNATURE-----

--idY8LE8SD6/8DnRI--
