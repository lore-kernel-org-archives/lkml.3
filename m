Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaKSKzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:55:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52947 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaKSKzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:55:02 -0500
Date: Wed, 19 Nov 2014 10:54:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@opensource.altera.com>
Message-ID: <20141119105443.GD22111@sirena.org.uk>
References: <1416338885-16773-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7QsOHKuLbhbLTwLB"
Content-Disposition: inline
In-Reply-To: <1416338885-16773-1-git-send-email-linux@roeck-us.net>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] regulator: Ensure unique regulator debugfs
 directory names
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7QsOHKuLbhbLTwLB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 11:28:05AM -0800, Guenter Roeck wrote:
> If multiple regulator devices of the same type exist in a system,
> the regulator driver assigns generic names for the regulators it
> provides, and debugfs is enabled, the regulator subsystem attempts
> to create multiple entries with the same name in the regulator debugfs
> directory. This fails for all but the first regulator, resulting in
> multiple "Failed to create debugfs directory" log entries.

Applied, thanks.

--7QsOHKuLbhbLTwLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbHbzAAoJECTWi3JdVIfQ+ZoIAIM+jXXhpNdcLeakdb/KyHXx
YJoNrNs6fDNnmtjfw5HU3+1B5GV9XW/c6LbRhwkfEnad7rMmKWVNflLZ7VSO2LZc
YVpMk+CXMD/c92ky9G+ukzWL3MbaRn7mDkGoRbnmJRNBqKosPPZWDti5OBQ4u/Ri
erzoIP+3lbq9ArVY8ReAUB1xbpMxykECKGkoTZ024DcJUc/HDHD/DDI99eXwUUGX
ZDYK6+l63ufw8ppbJbiKdeXe4GAaHai+lwch+bhm5uILkJ1b6X+kdhWxmzt/hlW3
21DijHbh1fo61el/3m5L8Z8cVvwHAB6OnPmyYSi6uei+aVp7RHfVoMVexjw3bS8=
=gTP2
-----END PGP SIGNATURE-----

--7QsOHKuLbhbLTwLB--
