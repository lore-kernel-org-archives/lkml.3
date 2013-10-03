Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3JCQaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:30:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48536 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3JCQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:30:03 -0400
Date: Thu, 3 Oct 2013 17:29:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20131003162938.GB27287@sirena.org.uk>
References: <1380716219-32039-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131002195029.GH27287@sirena.org.uk>
 <20131003161114.GA3635@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4NxgPrvSrIDR5b4"
Content-Disposition: inline
In-Reply-To: <20131003161114.GA3635@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: core: Add ability to create a lookup
 alias for supply
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4NxgPrvSrIDR5b4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 05:11:14PM +0100, Charles Keepax wrote:

> For the bulk API would you prefer taking a single src and alias
> device and a list of supplies, or lists for all three?

> I would go for a list just for the supplies, as lists of devices
> would probably need to be filled in by a loop on the user end
> anyway negating the point of the bulk API some what and a lot of
> the use-cases will like have the same device on both sides for
> all the supplies.

I think just the supplies is fine.

--T4NxgPrvSrIDR5b4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTZtuAAoJELSic+t+oim9A6EQAJIGxUp6vUoHGktPYfBOPbIN
jspfRjSZz7v9S6cRcQ1BDoaSsbo05x0xhRgd2tmatwGqpOr46sPFcuAITXiOlYxq
QWiTSAjOJdyAvWNWXhdeL1icZMuTUIYlBkdM7vZW+QFngtvx5RqO8bw0HQVrkZLs
egmR/UHxhDLNCErVBWp7ai6oKU26Z77sKz/+VRELxGr5Y1YJuZF+uGR+6H298WYC
I0HT9O9LSvJwQDXLdUNHK6JJ+OkvZaaZUeFVk2nv/9sa9Ahnil/NGYxBO8MQUS7T
AJKbShqYnJx2zsG8hPYELtsDXSZiRBKW/EJITihf5gdCx6eAdrOVKC5Cq/rrww96
vZxY3y7lRCRna6nF9ERRGGU89AKBB+ZpBxyGcjP5nnkaQCIrRWuY0RuYQ2lBgtpg
lsC31NZ6n2Ow7hJoKuw+1jKx0shD4IpFw7Xs63FHLt7uNklYgP6w1U1BQREItXB+
/QR/DLrN8THD4TE7PZOy+mIV97IbZUXWI3vghZfTs53/u7YUmQQgzkaiwxaV+/rt
WqvM7zZ2yvR1X/7nom71ePn6ItVVnyBcC7pQ3UVR4lpKw1sLGYdODYDb/YI2k9sM
/kG9T7Qenw7V6JuadUorVrXh1N8P4dsN+ZylQLtAmPnPLxopFHTrlJBSB7bZnOes
f2+ccvBRHCJE4MtIC6jV
=N0DJ
-----END PGP SIGNATURE-----

--T4NxgPrvSrIDR5b4--
