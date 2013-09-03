Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab3ICLVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:21:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49565 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759942Ab3ICLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:21:05 -0400
Date: Tue, 3 Sep 2013 12:20:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Simon <horms@verge.net.au>, linux-kernel@vger.kernel.org
Message-ID: <20130903112050.GG3084@sirena.org.uk>
References: <87sixrre8r.wl%kuninori.morimoto.gx@renesas.com>
 <87mwnvsy7a.wl%kuninori.morimoto.gx@renesas.com>
 <87li3fsy69.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gHypzss5dW8YUwgb"
Content-Disposition: inline
In-Reply-To: <87li3fsy69.wl%kuninori.morimoto.gx@renesas.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] regmap: add regmap_field_update_bits()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gHypzss5dW8YUwgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 08:24:50PM -0700, Kuninori Morimoto wrote:
> Current regmap_field is supporting read/write functions.
> This patch adds new update_bits function for it.

Applied, thanks.

--gHypzss5dW8YUwgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJcYPAAoJELSic+t+oim9vBkQAJeU5r+Rxwl5iRGGY5FfyQAJ
9zto6qh5wBg7qh8ZP0cw4JGzDEvtzeQ32E8i82mmzCus2h8EsLc8KdN5VfdaIFAK
8sdzrep37tAeNasrC5MdxlUxn9rQ3YpJF3CHyVpWrvb0fQI5YQMZUORAoDOOolJr
V2O3YBrinl/mBHCqbBywOb4uB25FCtOsCMrrHyUYiTfrGkaz9ld9p4UJihcfXspj
aYjMzFe7Lvk6S+27R0sG1yO7XVBINVBIooNhtLeJ8zj5OMTRxAM31GT3d+8VrMBE
tVASx4oR8+FMXNBZ3ytNhhzI1ZllQJIk+vV+MUDn5iO4XEFaFyJH61dv5v7LaBnH
aAQqrFw5NbbYVgZ93h3xdXm80qmzenacg5BVcK/CBC3UCRk09+qkC6t5zwnKTsRw
9HAN/At1JlsxbQKkj8rU/BcyGuNYLP76Ltrb6cAdo+sB9GBJUOXdZ4ZzoF0rKevq
jsZrW68vFwDxneX5dt+aezgdd3j2DG/v1Cx+Ad553aBJAsZfZEpraWhe2/2dVqlW
zkVFBzJ+sQQCowPxS6bmGSnmP3edu2+w2Uzl5k34FJgGccoamiV1MGNZsdorm55t
nN3DaknUbbzNqSa3Dza9t9hlfSB4TarHdggOk9839QjVL4ekwxhcxqC7rYSWOgus
LINX9JSonn5FwsKdDjb9
=fwY8
-----END PGP SIGNATURE-----

--gHypzss5dW8YUwgb--
