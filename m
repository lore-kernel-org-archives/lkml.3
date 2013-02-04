Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3BDKZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:25:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36896 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab3BDKY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:24:59 -0500
Date: Mon, 4 Feb 2013 10:24:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: palmas: Remove a redundant setting for
 warm_reset
Message-ID: <20130204102454.GG4720@opensource.wolfsonmicro.com>
References: <1359895796.4157.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Content-Disposition: inline
In-Reply-To: <1359895796.4157.3.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 03, 2013 at 08:49:56PM +0800, Axel Lin wrote:
> Current code read "ti,warm_reset" of property twice, and set
> pdata->reg_init[idx]->warm_reset twice. Read and set it once is enough.

Applied, thanks.

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD4xvAAoJELSic+t+oim9DcwP/RLYa3MKDRdlpJzS6N/UlbnG
0p3hU0ubSzGzkU8jbgxyHoNyydMdyViQaPFOGpeK0XSxj/30djjMas7KRj7E7wFk
5D6R57kaUnvNUJBUvK7LmK5azupFPrhglkPg3eRcJ4H6pXVZXoTMf8GeCj8Z9z8W
3hmuxIDetDz7y7MykKM3CMjGhYzwb7gzEkk+CrsHjvPe7qF+v0Hz4FILZXOvQfKA
CUnE6fv/mokkxzMD1HQUAOrqidYPjZ9BDvh6hcUb9uRFg6rum/TW4YVWKV12CTlt
auqtbCXvi8v5zaUQt6AwEMMnbZ0UdJLDUVtVqft4LvPsvAc3QEvXu/ivzt7SHfZ0
qZF2x8SDNYXIZsgK+XmVO+P4ISdx7riGHXEgP+y5XP6o7VDQS/alzufthjm2WZBd
J+cLLycbsYqr6U5W1cnjTLCLaxYmuII+DtxvrXdmqlhhmq+y7wjNlChVIwoAtTNA
P53mIhc3aDzYEgNv3Yoz1eu5C/xNQd42XK50EFbgYanQw84bjCKR0Ep8G3choBt7
5z3ODCe8ges8ApjcoPExZvw2zSAxH9JR8Lro3tz9CwMBqdnD82NbxmVtjAAQ6jUG
/gqmNC6tQH/jbb4E02l+kdaJPhgXB525mFdw6k+FMG9KMT8rXtgrm7FEro3n5QdO
bqDnAtAeSbeVYU7lJSJw
=bP0s
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
