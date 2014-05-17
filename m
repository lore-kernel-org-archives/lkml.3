Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaEQN2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:28:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59906 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbaEQN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:27:59 -0400
Date: Sat, 17 May 2014 14:27:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Axel Lin <axel.lin@ingics.com>
Message-ID: <20140517132743.GZ22111@sirena.org.uk>
References: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
 <1399302603-1427-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iPee2xDJk0Qn30ik"
Content-Disposition: inline
In-Reply-To: <1399302603-1427-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 217.44.186.29
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: s2mpa01: Fix accidental enable of buck4
 ramp delay
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iPee2xDJk0Qn30ik
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2014 at 05:10:03PM +0200, Krzysztof Kozlowski wrote:
> S2MPA01 supports enabling/disabling ramp delay only for buck[1234].
> Other bucks have ramp delay enabled always.

Applied, thanks.

--iPee2xDJk0Qn30ik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTd2PMAAoJELSic+t+oim9+JcP/2BLPC7Wkq83eIUCZLQsMt7r
7MyzDLIOrIq4iueB3L6Ehgn7n/7K4SyngJK7KyazYJeENH1BYVyTuD7BN2TRtLLI
7pNonbUZWis5CJQ6yhyyW1kv8e2wXzqcqK8wMp02XgRWDG1IOR+/YCf4CgfvhzZb
W9HgeS//rJ833SkdJwVQLUksxVrHczmvHCHaCMegJM4sYhh9GlE5P5kJq2cVbAeS
f1M7Tu74I8bBVfwlBS35EhvzfwlHoT11O6mvkeiKESYPTNxxgu9VOiRo2yOjRaPO
oROPXmmNkuSqkZlFj5Zor4qjDEM2EBdAQCu7Kp7YWTQ8AP/7EgXVnkFH0HU/bz6r
FyT6WqSKmuxBuiJdVKpQSWdvDvamSXnaJXC3bo2VTF2XJdzGQqc9U5RT/qhAxv0T
APSB5Qbcj6sw+efZenzBjanTeXdA8e3wnmo8jeRCaL3VIU7YVsYPH646v4U3QR0C
h/OLxgvhJFBAjz3zwqArrsKkUaOe0XZwAUWHO/LxHRGBgUQmi1idsJf9cw+PaYqz
lyPROj0/+ulLznmVlCQjKWOpLLzMNjrejT5RJnvhFss5zHXTWXsjWifTkR4Oh0yn
glHyME8xKsOZD3z1qYp+czt3/6fPpt9ELL10FGjxqY6O37YIsHyxTU/2nBdcxRcR
9Uajh5fvMvGXYFFdxBOG
=JUsN
-----END PGP SIGNATURE-----

--iPee2xDJk0Qn30ik--
