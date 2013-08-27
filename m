Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3H0PXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:23:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35943 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3H0PXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:23:35 -0400
Date: Tue, 27 Aug 2013 16:23:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130827152328.GA10783@sirena.org.uk>
References: <1377601383-591-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apg+fY3UKMMABzWO"
Content-Disposition: inline
In-Reply-To: <1377601383-591-1-git-send-email-lars@metafoo.de>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.140
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regcache-rbtree: Fix reg_stride != 1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--apg+fY3UKMMABzWO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2013 at 01:03:03PM +0200, Lars-Peter Clausen wrote:
> There are a couple of calculations, which convert between register addresses and
> block indices, in regcache_rbtree_sync() and regcache_rbtree_node_alloc() which
> assume that reg_stride is 1. This will break the rb cache for configurations
> which do not use a reg_stride of 1.

Applied, thanks.

--apg+fY3UKMMABzWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSHMRtAAoJELSic+t+oim9Z4QP/i/J4KUXRprU5TWq7bDEGk9y
uaTajVinrHq90OPbShv6bh0lE9/bp95Qh36WY0WmdCeRcW8VEFIGTb2aO+RkGtd+
IJzS4582f6wE/w54GjCPdKZQ5VktAwPWIJjySDQkwMLmXCp99K9QI7Je6HcPRgGa
RYZUlbvoE+Gh9bZ7mffWVX2iBnzAhfqclF79Ffk7/wbErGQoNyxY29GTFLPL6T/C
2S7b4NKrn8wxGBuGcSJZ46avJ9Bhn1ANzF38vZ0Olt7f9aniyaz8Bhg6WgEi5TvT
BL6+usR6LGQCoGTIHcDLRx5FlwuNdBCOrzwG+lLVQOorKKQ+2/y/Ei+WnM6R7vIJ
nX03DEskzrAYObqjhIf+wyRMacgUb57p899fcAnsiUxxMiJINHnrnetaL//JDyWS
hD3mX5TCXTk1LXSQOssLaMQImz1mLkh2COgOJnluSY2/yPHJnjqHuL6wuc97MzYs
dRqv6lmbAtLWOX//u6Psmy18ai4av2LfjptcjF674+fAzKFo5xFGpT57eyc14b43
WkIMUbeKRBTqn90J+kH82vk4OQIMf99seiNgOc/N5rkxBEYbfdHwy1dvHYKXg4S1
fLm3yT89X07grXvjTSo/7gUQCZgmOVoCUM6wKFqyzcwizLohqDrNi1ejCzgPKp6k
E5eE5qrntbEF8liBCwzj
=jObM
-----END PGP SIGNATURE-----

--apg+fY3UKMMABzWO--
