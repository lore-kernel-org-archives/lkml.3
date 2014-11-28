Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaK1JSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:18:46 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39921 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaK1JSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:18:43 -0500
Date: Fri, 28 Nov 2014 10:18:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: swarren@wwwdotorg.org, gnurou@gmail.com, pdeschrijver@nvidia.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc/tegra: fuse: export tegra_sku_info for module use
Message-ID: <20141128091838.GD5978@ulmo>
References: <1417162573-19155-1-git-send-email-vinceh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Nae48J/T25AfBN4"
Content-Disposition: inline
In-Reply-To: <1417162573-19155-1-git-send-email-vinceh@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 04:16:13PM +0800, Vince Hsu wrote:
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>  drivers/soc/tegra/fuse/fuse-tegra.c | 1 +
>  1 file changed, 1 insertion(+)

This needs a proper description. You need to explain why modules want to
use this structure.

Ideally this would be part of a series of patches that add modules/code
that make use of the symbol.

Thierry

--6Nae48J/T25AfBN4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUeD3uAAoJEN0jrNd/PrOhHDoP/i5ccHqBOXFGJfIJRFTulL1+
Yf4OlnMp2CrzKykuHj1N4uWw8WX7Nuczs8IxixWMAsVUlwW/4nDYdR+OOWlvZUEd
z4HhrsQjgCKwE10Gj4n6PUlGUyk5ZG1/IjyTr+Lgdzmx60S9eBmVfF7U/4CQsZVV
cFJoxd7en7sxJJq6cr8A52HtEypzd7iKHvoVtcHDJqO9019jHJ2ZJYq5OATumV6E
hA1S/eHg9ZhAgIhTP04oJTZAEufmKpeXgdeZwv06Co/P79rSbMHdVEdUs/UZ/19H
4Q/98cvpCBwpc6se8sNt9uqnsqvDi8yVDiywUKGDTuD8+qdTCyxc+lBqe+6Yvx9e
PgpBTDOT4IM4eblkBVuQeqnhAijY3w7Jc48Z2Qt87vKsvMS5F+O+0yIAx5D2qNPg
WVZn3a7/2H54RdVrb3SP64+HwyWGIQePqECZnV2LxBN51/kkX4I+SMNzSRdzh70z
Mr7xbgeP1Fr5dd4f8hnzk6q+YOZdc8RqDrhQ3CHnwTX2ZJA+ySp4xHAnstCeZitS
OMbhT7QCyNvpK5luKIqUEVBW7zwORNSQUU0zgQ6YJvjPe4zjpbGGWJGIJDBxvqs8
lm8uKKr5p/fSyuAxZ7DqPaWzOyEqNdpNlTdDcl3RMMzvj8QZqBw7hmVqB20sIiWT
PtWLOzU+BniyGtsW1Ood
=alb/
-----END PGP SIGNATURE-----

--6Nae48J/T25AfBN4--
