Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3ITQma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:42:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53420 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3ITQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:42:28 -0400
Date: Fri, 20 Sep 2013 17:42:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130920164200.GP21013@sirena.org.uk>
References: <1379677916-3857-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C3csQhHPgbq3tf44"
Content-Disposition: inline
In-Reply-To: <1379677916-3857-1-git-send-email-treding@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Reduce busy-wait looping
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C3csQhHPgbq3tf44
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 20, 2013 at 01:51:56PM +0200, Thierry Reding wrote:
> Keep busy-wait looping to a minimum while waiting for a regulator to
> ramp-up to the target voltage. This follows the guidelines set forth
> in Documentation/timers/timers-howto.txt and assumes that regulators
> are never enabled in atomic context.

Nice, good spot - applied, thanks.

--C3csQhHPgbq3tf44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPHrVAAoJELSic+t+oim9aN0QAJ28biWmOtnZXXN1xZ9AhHGu
4jJPr25wDck2p17P8HP2eAmX0XxIIkQ5qCiodE4QFBid7T/kRbaSYYbLBbAgQBq4
vf/EikGGDbsl7aaomOuc+LK5Wkm6Bh6jeeq/plMG8oL7fGmC/C8ER2qZDy8oULxD
Dnbiyn07xxZZFSRUM53vJrwYf8aVg63OUj+H+hu4y9Mt7T0LwAyCViSHbqTw31Ir
oLVDZ679FTSy6wnaSxUuFv8iIDgFZ2G9VJ6v9FZsqH4yiA/45Y1UaKPXVXV//+DS
p79g7oNDIp7k1+0ga34rpPPxWuZol2ogUv5IgJPYBqzoumqYCR0KP7LrlZE3UYIl
X5SoFOfCsdcO5+XFvxGLC4+6o1HWyQIfS8dAZx39cfDoRxapyJdTXZ0Sc5cDm3aU
DFzRKH1/QdLv0WGEb4RgLVO/AfGkPK9yvJpy7p6TIj00x7+y5XLQM1zbPfXp74Ri
1lX96carb1hVuARIvko97tdxtyiZI2OxawCihPWnTWju0JsvT8tolmqMRiz/nHu1
K48QJIPg+QWRlsReZeC/FLCNEz8874gH7ZSqmvxAC1zdRV5JAcfJ0vS8ji2qr7jx
pZZaDJp4fZwuD/p9qdo8ipsBCbGUO78qpHVKmEVlH98dUi9OGEPVs0SZhJUUWboh
WpJFHGGrBifQmEeOjmFH
=naDo
-----END PGP SIGNATURE-----

--C3csQhHPgbq3tf44--
