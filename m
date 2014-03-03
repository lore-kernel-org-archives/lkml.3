Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaCCI1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:27:03 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:65117 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaCCI1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:27:01 -0500
Date: Mon, 3 Mar 2014 09:26:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Mark Brown <broonie@kernel.org>, iivanov@mm-sol.com, gsi@denx.de,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: core: make zero length transfer valid again
Message-ID: <20140303082657.GA3372@ulmo.nvidia.com>
References: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 11:03:16PM +0900, Atsushi Nemoto wrote:
> Zero length transfer becomes invalid since
> "spi: core: Validate length of the transfers in message" commit,
> but it should be valid to support an odd device, for example, which
> requires long delay between chipselect and the first transfer, etc.
>=20
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
>  drivers/spi/spi.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

This fixes a regression on Venice2, where the keyboard controller relied
on similar behaviour, so even if this is already applied,

Tested-by: Thierry Reding <treding@nvidia.com>

Thanks,
Thierry

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFDzRAAoJEN0jrNd/PrOhXRAQALzffvNggGCqfoE1w1AU0HNt
fA7Jd4GZgGr8jFMBuE9eSWaWG2znyDUDeGasfXWgy/PAzIlCYtElLuwm1qyca9f9
NMjuiGDzIJdyMY0NIFwKCzsxu1LbrnytYvIBsnTuDrhwx740jZuLYFzbY4iJmZ5U
Vw6nzZZwLB/lUkQTLkGAW4qJMYSy9tcBlp/DfZ/eShwAL0NwgBJkVwyRkshIBrF7
t8jXEcs2OFeIYuLZEzxNd0bB5l0TDyxqiC/nKWu0e0UaNe+CctpfDjB4w0p36+yO
0vyCmhjM6tyWu6yasTgN05IesvU4JgHaIPbv/ZTaPVQhn0TSPRsG4DeFYLDJIINZ
E73K9JUaGY4flUFt5c/QcL4sxG+t7dl0xG4OMJzL+nnh2RiHW/QipBN+BHf2ZJdn
xtSUCZvh3gFbv2X4oiDuUOCaTZqWU4MnJum7e35JZKIzoouera7o7PboKKt4f7Ik
P2ED+ehL8sHK4HxRg8CpG1pRk4utSL9tWuWteQi2Isj/jsQNAOWVMEPfy7F9xAUU
y4GP51DMlTjPnquGFfIvymr/ShoH7HqCtH7AADSnntPJON26s4x70RGv7HAS0RLt
JrtukyAO2Gy5UMQtTnBhPhzIaoC4ZcY8dNMhwoo1DYavM9TYqs9tcSwETzVKqx05
xgrZVYmEb+jpHgsWyCc0
=WJjo
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
