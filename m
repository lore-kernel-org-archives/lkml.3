Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609Ab3IDJky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:40:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55806 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab3IDJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:40:51 -0400
Date: Wed, 4 Sep 2013 10:40:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, axel.lin@ingics.com,
        kishon@ti.com, gg@slimlogic.co.uk
Message-ID: <20130904094023.GN3084@sirena.org.uk>
References: <1378288206-20741-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v1TsIsr/WJoL6YzS"
Content-Disposition: inline
In-Reply-To: <1378288206-20741-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: fix the n_voltages for smps to 122
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v1TsIsr/WJoL6YzS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 03:20:06PM +0530, Laxman Dewangan wrote:
> With the following change
> ---------
> commit ad02e846878ca35e9d3fa584be8ee770e9e14fce
> Author: Axel Lin <axel.lin@ingics.com>

Applied, thanks.  There is no need to include the entire commit message,
just the summary will do.

--v1TsIsr/WJoL6YzS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJwADAAoJELSic+t+oim9sqUP/jlXBD+gCYGkB2RdEaxoVmdo
RtTB9n4r2r3OjXAn2AO8/gm92qxcTxa9aKEzY3kfPLBSo3c0DhRcIYP/qfSTpW3u
Z0rbbfC6GvuKC45q0incehQfRDb28pZOX2VXTFksdjiNVRrS8KqC0xpe35k83uRt
BSMqZYWN3JAIW1mqgOm+DcAVVPJECOVU0eXLqogsYDjegIKr7WyVzV1v4OnTyUio
X+PnqxmlQblHhqoBQ7TRaSx9ZXKlPJ4frGU6Ri0DpUnBWx1z/Yr7mgeurtxuNQnU
SBD+BzBw4s4hFkm1cxcqhZTStgmbGgSzHLQZUMAkYBdqHc2kB30ZkQsULIlrnuQU
crjadu4AmKvT2CfXdcUjmu/6tnks9/pHsQSf9H6tFAw1uySHjUMWFaa/nsef3ulW
udCKb8uBPh9DB6X97mZc4ufwRSr9fKr4ZbRjO9yyMp8NCm5DoJKBoHk3yg0p5psd
AfOgHKU4B07go83sbrzOWrVOLNvqlx6DU8EWL4yZd93c7w1Q5JxwKO8DoSRUAeiX
5vXXVpTuKnV+Crv0PmHTIed5xkKRDezamPnPZbPF6tmtZqlg5Bq/DVybcYCK2cOA
hMWnH8yQB7YWV+c40iS1+SMygCdUPefum2J6KrBl7E5cmm9qTufi26GK9lxvBWaw
B9aKZ9UzyyYLSA1t9hL0
=syr/
-----END PGP SIGNATURE-----

--v1TsIsr/WJoL6YzS--
