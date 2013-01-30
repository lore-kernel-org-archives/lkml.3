Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3A3Ky0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:54:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55617 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab3A3KyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:54:23 -0500
Date: Wed, 30 Jan 2013 18:54:15 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFT][PATCH v2] regulator: Add missing of_node_put()
Message-ID: <20130130105411.GD6229@opensource.wolfsonmicro.com>
References: <1359292616.11083.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <1359292616.11083.7.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 27, 2013 at 09:16:56PM +0800, Axel Lin wrote:
> of_find_node_by_name() returns a node pointer with refcount incremented, use
> of_node_put() on it when done.

Applied, thanks.

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCPuRAAoJELSic+t+oim9JsUP/idPqadTCC8jWrLdYmv7JeUQ
s1TbX9oQewsGoqavXOuFVbuUcOhfhmBiWZQd825x7sAbNAl6SYct93/qSZofLdqt
ojc6pAW26uGA4QUuj+BIkndwF7XR8DMmfs1YwZnDVVO2d1SyMIc7MWNRPRNCZVx7
NlSBaZIAAacrGA9C92KC8u6MAVlrsSp6vn7YsYVdvCkZjw5N8vtMnP25RQFAU9zE
8FrpOtooJR9QY0eQ/cS/ixaDZA6jPAYvJVczTYsU2astDdmIPdNyOFbIdoDfwiRK
FC0h7CaHb2vvFzpwwJeN76B2RU6PgARBMqtnKwm+GECI+PhE8Um5o//59oNrNj1N
4X2Y9shcdKSAeDX5WXx+B4/8qBByHQ9qOsUDZ44krsokrvfabQ/NA8G3RDyJlfx6
E9Z8mCHb/bXSg/vWFvcJd2ond6ht8ngrCo2Nvttzhvzj8cwGPYwyLEFTPzOl5B4E
D5+zcEUAjoEop8nJAvhryuB3wPtqzao2bMiKQpIZOYIaL+tzl6ANFXRHstnTH7gv
SxjDp9wBP0zrvA+hd+xhzrtvi9aZvV7FsDrmaYQyGAqx9Bcx8KCGbKZ+bkpaEWfN
E3Bl7BucjcXZHRbIhEfd3BIePZBuOd0YIu2VXrP7jTMvXCVwvxI+MLmwKCdA3Sry
4rPtTGZb3XP4b18+1mtw
=NYHx
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
