Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3KTPUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:20:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45141 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3KTPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:20:48 -0500
Date: Wed, 20 Nov 2013 15:20:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, tiwai@suse.de, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        perex@perex.cz
Message-ID: <20131120152024.GF2674@sirena.org.uk>
References: <20131120131547.GA7357@opensource.wolfsonmicro.com>
 <20131120143709.GA12897@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k4g3xMTzTwvmb7wy"
Content-Disposition: inline
In-Reply-To: <20131120143709.GA12897@opensource.wolfsonmicro.com>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/1] ASoC: arizona: Set FLL to free-run before
 disabling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k4g3xMTzTwvmb7wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 02:37:09PM +0000, Richard Fitzgerald wrote:
> The FLL must be placed into free-run mode before disabling
> to allow it to entirely shut down.

Applied, thanks.

--k4g3xMTzTwvmb7wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjNM0AAoJELSic+t+oim9ZssP/jEsE5qIb8cjcwdJmOmynRJd
794GNC5BIUKEqKCyKBFjQ7nOSLXrLsTHE0wc1OFL6OEoxQVBNQ63WVATHg8P5JeK
kd6kT2SVS/lqmVB4Lnxe3CIKs+8Z8rD7Ilw+IrORhYVRm97/e18xE28eG+E5D14s
4FFFu+sLvYbTnCGi6Zh2MZ7/5HP6iLjiRxs9wT8nEaxh5OKUwwco1kSJjaUrALi9
bvhSGrL7ti5gDWlctP5xoUJjj2fuhroC6q5g3YFtPFSOKc9wZ6n8T/HmyiOO0F8v
PpPArQp7YC9/vCsYmvqDLZybDC9KtyEvQwfdwmwgW3AnDHrD9FATv+E17OPCDAt1
5Z/hMouMEHaFPSei0uSnRT2dJCO9MbdMVSg5l+Ujh9K5yWsrBf6X5VpTmykSXhLe
chaQq68vu8vcCULZY6+NvVYuCrYELZM8tUM3LuGf0g38Mm0uqP/nHUwr0PJBLRMO
91aZ6bUi5j3YxVg0pozukxrBEFp3yFFp2Oj4K5JHXGfnRjJNesE3ozhR/Rdj5YJK
wfj2ipUa/LA4XD/H9D5TYQBJil8FfsAmv+P5LIUj6BszinVeVPvF6gFvWybNoC9S
V04885fpbOzEwJ9AO2K4115jSgP1n0YXhIqIinrTFeg7nkKu3evQcBUpbYiKsr6d
a0lh4cDikaN8PhzKnGNz
=JBqQ
-----END PGP SIGNATURE-----

--k4g3xMTzTwvmb7wy--
