Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3AONqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:46:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:43146 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab3AONqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:46:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="asc'?scan'208";a="272266142"
Message-ID: <1358257658.2731.140.camel@sauron.fi.intel.com>
Subject: Re: [PATCH -v2 13/26] ubifs: rename random32() to prandom_u32()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Date: Tue, 15 Jan 2013 15:47:38 +0200
In-Reply-To: <1357215562-6288-14-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
	 <1357215562-6288-14-git-send-email-akinobu.mita@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Di2XiKRPZcm5S9NL7AHm"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Di2XiKRPZcm5S9NL7AHm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-03 at 21:19 +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Pushed to linux-ubifs.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Di2XiKRPZcm5S9NL7AHm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ9V36AAoJECmIfjd9wqK0UJwQAKGj6JVnIfCrFsLWSh8d0mYf
pqpRlg5SXS6cZ9UBAVH1OOFxYbE0mclXH3EsK+5KxBaIAMehfqZ5p4/il4JVCBII
lrgLDNNoQdHiUEQV+KORDTVymN/ppHHvIxXFQQPLk9fJXVvgEnOrqcglSikZloB0
SMytJrQ1mGrJCwvjw3aL0TwVzhCAROSa/aU/BU9+LWff1SufIsDd4tUa8nsMuEAL
uYf80BBqkczk2GePWZ4TIMRN5gFRxH5obRq4I7WnGoo3ndDj9M5460BybFPxY8Nj
IzZAKLiXuLJa9keYgKHfz4JvKZY+Ny1cZfhfXFsmnPu+cwT0PixFwPwiPX0d8Nfx
O+erANNd8UjHJpW51rsKOyER4l7AYnvXcDuu7lSb9kGfMkac1Cdpqo+W3JMF7bHw
M/UqM9q+yKbLAudhrpvAVggKVEU96B4VoV9s8tgpUWZfPjJ6zEe+RmGX9axx2EVM
YzeP+yTFTy/Eof7HJqr7lkyv3ccCc62HMRZLBKgeqH6r1ZQNRW+E30A0iB/1Ydd5
UttvwIBbBiq1TqV1x6PVMYXio+laMAdiQ5OG+fqg6EnPjCx9kUhLK7ze5TluVFrq
dWLEWgTivHoEp0Yf4605190K5BOQ/YmWTrDXem3zHKfdqF5pk2DgaJ9iShfB5E/0
hJNLZIzXgsJ9PUMoVvXt
=tSLq
-----END PGP SIGNATURE-----

--=-Di2XiKRPZcm5S9NL7AHm--

