Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3JHJfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:35:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49279 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3JHJfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:35:41 -0400
Date: Tue, 8 Oct 2013 10:35:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20131008093511.GY21581@sirena.org.uk>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
 <1381195662-28009-5-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L9fXoLhVbEF7eqMD"
Content-Disposition: inline
In-Reply-To: <1381195662-28009-5-git-send-email-gregkh@linuxfoundation.org>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] spi: convert bus code to use dev_groups
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L9fXoLhVbEF7eqMD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 07, 2013 at 06:27:38PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the spi bus code to use the
> correct field.

Applied, thanks.

--L9fXoLhVbEF7eqMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSU9HMAAoJELSic+t+oim9/AAP/17uiXrEgPidlQoZCMt84Ltr
5POaAYsOC3Nr7jOqn+I6dtSH9AjDhJp5CEL4/Rscja76NMGdTVOKq0JZMOhzQVoY
qkC/viqOshBjub205X00TKBBjM3bzdxsxiblvm3j8ZxIpYPp3NCHOqewRkomLT0Q
fL+r9mo+mHsddl8EbwI4TgbPXyGvdabWj36bUjLa0ifqPa5bs276SOrwDvO1q36h
alB+vSvR8evD32haLJ3Gmo8p2puRnwH2Wt6+CDJhc1hJg5uUoFd5RmXYMpJIocQi
kAO7PJL75d81WvSt5nBVYjxytop5ylu3cmFQDWi22ZCwDcBrOFyBU52qB7uxjDXg
eiQ6T92SwnCKFfcKcez2yzsNe9pp+8Y+d2iZ0EygfypR/Y5L84GMnZS0SVcZiz/6
A9M8kwzFbQubgr03xHzM6dd7Q1cTr0GS8H/FP++ATxp860a8txg8itaPsUNAie3Q
8pq8A8RWMh9bp0QVZ3sPi5B/jLArzVVewMtmnUlAhNRhnx/KfYfM4uOc1TbyCyKD
/HlF7K/KMK3k+89JT2jmipbLtn9NcAE/bP6thL8jGSlXoYru3aVFWpz64TCvUnz1
k0fpCZCpU/CfuchsPNtxfnPbv96xefK3Ma4ogrFYw0dltR+JkLW0xpgp/Ju9K2yG
16bTO5B+b0YgesuUgoP4
=5Gd9
-----END PGP SIGNATURE-----

--L9fXoLhVbEF7eqMD--
