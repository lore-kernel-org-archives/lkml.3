Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946304Ab3BHLcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:32:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38348 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946244Ab3BHLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:32:34 -0500
Date: Fri, 8 Feb 2013 11:32:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: debugfs: Fix reading in register field units
Message-ID: <20130208113232.GN8879@opensource.wolfsonmicro.com>
References: <1360234316-8749-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+cfQkLQGU7KOA/8T"
Content-Disposition: inline
In-Reply-To: <1360234316-8749-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+cfQkLQGU7KOA/8T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 07, 2013 at 10:51:56AM +0000, Dimitris Papastamos wrote:
> At the moment, if the length of the register field format is
> N bytes, we can only get anything meaningful back to userspace
> by providing a buffer that is N + 2 bytes large.  Fix this
> so we that we only need to provide a buffer of N bytes.

Applied, thanks.

--+cfQkLQGU7KOA/8T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOI2AAoJELSic+t+oim9J94QAJFK3dA9EeL91BLtWYQSD7Pg
iW4e/rKo7fMM7y0RlUgyZg3xidWaqsgd+mVSdbh4SZDqzIdafAirXOPsZyHHkEjw
Mw7GcTn85+UmxhLcXCcoZpNPT4lyHh0E40rQz4Jr9EEiFmf+gAIKODEq5dfND09a
LcCCYP31oIdt/wYqUaTm2bU08V+41b7ujcyqh7fjr9PLXCHv+JpEmZlYB3HXyUiV
Nv5xjEn/ec10WjnDpPcG1figuevgzTHfhjrgEAlNekFkkIsbWiKr066ZbaulcC2W
hG+Byt08rGZsgwlqFajKzhvg4lMkd74bFdof3jHhTuGoDiilY1/Y0kzaQuEkvcYp
islt3KCGvBtHhvDGgxmR9wElyBzLf7+cIsqhiP1dSKJMg8V5KPaKbU/k6D2X9nxP
7+/Nju+l+rt1Z+xyVfWnSq3ulLQEJfND4RL46ArIeIBhGVUiVl/7bOstjhE5gvg2
QTRHLeLtDVSP2QioOQh/rZVmHJxWLOQUH7JjqaW1tcfIsZyGo+ZyyWmfIxpjgfXU
8dF/XRfvhL81sK4w3sqAFrXGVxf9dBUx1tLI1TOyef1fQYJkuaoKXrrvuPuw79B7
rXwqqCzZbZkmo20aaO2fpuI6Hl3OZ8RqOgUYvIXtDUHsQeWFfE1gNnG3Ly1XkJu3
Y3lGomlKy3dCliaeaPpw
=aeRa
-----END PGP SIGNATURE-----

--+cfQkLQGU7KOA/8T--
