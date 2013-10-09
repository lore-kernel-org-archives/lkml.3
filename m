Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3JIRwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:52:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49987 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3JIRwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:52:02 -0400
Date: Wed, 9 Oct 2013 18:51:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lgirdwood@gmail.com, swarren@nvidia.com, linux-kernel@vger.kernel.org
Message-ID: <20131009175155.GU21581@sirena.org.uk>
References: <1381240864-19639-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yeJdj7Q1OCGij+ex"
Content-Disposition: inline
In-Reply-To: <1381240864-19639-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65090: get regulators node from parent
 node only
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yeJdj7Q1OCGij+ex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 07:31:02PM +0530, Laxman Dewangan wrote:
> As per the devicetree binding document of TPS65090, the "regulators"
> subnode should be under the parent node, not outside of parent node.
> Hence to get the regulator node, the correct call is
> of_get_child_by_name() rather than of_find_node_by_name() which searches
> the "regulators" node from the parent node to end of DTS file.

Applied all, thanks.

--yeJdj7Q1OCGij+ex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVZe4AAoJELSic+t+oim95CUP+QH/9uiKBXVtEGUqcA6vitRO
ksXkZ7eZryvOFyArvMfZ9nsxZZ8z5j1jyyx5cpztZt8Cw/XKgf4/BtsKvWcBUsFc
ph56kAynndg6m11Oksx/g37hrVO7tdK+FMJXz+a/Yd1V/La+r42f4o3O5YpLI5bP
Ne3E0ercXmwRMT/vbGcU49CBR+Lyy4aDtFztdFXfDPskgWioLNa+VqF0QH2vHais
MV9qV+48y8lFW1Qv8Itxk2h9KX0CD+bN8wlTDx+ydtiq8buxB7BKvYLAYAgKXVrc
EYSESd/6Wz2yI6EGP9Z11tmiK1gIs965RByUlrlhwvAkSOyeQp5wPcFtWsKNYisq
IgQ6PIcjz7eivZ4zo8Z+NAutxdBeFnx9AKfC3+i+gYizhhB98tfuIbmqUPNDfngl
24k0jWh0hp3pK9NkHU3s2s9YnV8lk38QntmorSIgDZW8tEZ8Mb8/nEeGB08Y/gt2
AhFDnAFzbKsYibB9JIFSTKHkuZz/wc/s7PKfwXCJADTCz8bJAs+VEj5nb9OEA1GI
VVnYEfSxwKX6686Bg7FUOSfd63AhT8s3VC5xrakonnKk3H4me5V2zp9l4AaK8Sra
7m4GOMw5mUoIII17LoFGt002dG0ryQWkwkR2/Ap4GNrcTMohdI6ydXRTS7FMn/GI
j/f5t6RhxPIhs0U+jXG0
=+YED
-----END PGP SIGNATURE-----

--yeJdj7Q1OCGij+ex--
