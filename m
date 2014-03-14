Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaCNLBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:01:22 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36836 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaCNLBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:01:21 -0400
Date: Fri, 14 Mar 2014 12:01:17 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, Thierry Reding <treding@nvidia.com>,
        gnurou@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm/panel: use gpiod interface for enable GPIO
Message-ID: <20140314110116.GA27600@ulmo.nvidia.com>
References: <1393650059-5152-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1393650059-5152-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 01, 2014 at 02:00:58PM +0900, Alexandre Courbot wrote:
> Use the new GPIO descriptor interface to handle the panel's enable GPIO.
> This considerably simplifies the code.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 69 ++++++++++--------------------=
------
>  1 file changed, 18 insertions(+), 51 deletions(-)

Both patches applied, with a slightly modified version of how this patch
handles the optional enable GPIO.

Thanks,
Thierry

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIuF7AAoJEN0jrNd/PrOhnqEP/3VlhzZl1fJYt2czvVMCFq9b
9JaQXlTzv+ZjJkXH1dtPV8O+fqLtm+ThrbTV+QzoXzALgFgMjkCEItH6Pw/Of1Tu
8JRqN/biEVG+S1S3Ku/ZcKAHfItY7GfjL7q36vs5klS3u9CGRCGpPyQQXz7F1mFx
PMLbMdL7dOopH2BJUQeK1IwCNEiXRU0koRHMzsubrs08rT7X4fZnK2cQjOXh2Fw3
ilXtoa+QwBEdTFZss5KoR4vrl8+tI3Vuq3XUYmV5pDZle4X3vHzxxINqQofpYgQ9
xmuMWKKW8s2VfddkhWuzgHxaAeHuISVa31LkzU/tpUsVlGuHn548JSb0pHGGzeDL
uxv/yGxVOGNhc8lPMm7TFNbSt3c/PUU1fBRaYq2YbQTxDxjSPIjp3GTQAmZxaPJm
sGc6p4enFuwf+Du0dWMS5X2iwHc56CgaqZj6VdY64gdqsRdW0hoJDlKkNhquRfUi
oAMWFjXjnaRsyKUCmVWGy4r/Ih5Kc66E42BoJAf4na3NUKAzUOnziH9pIJOqKQXK
D3KFCLMwSl1iUIK7gI3oMfCoD/hjnb875+mfp4p8xkRDEFwF3rdJ9iS5layrSyHI
1M/jf8/dnPsu8myFCvwdo7buUO9oMZNSb7N73oN5kAsX+8qBBPrzO4OTdHQQflzF
BfUUKCcmOqdrliim/2+G
=BssI
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
