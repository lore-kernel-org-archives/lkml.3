Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423282Ab3FUPTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:19:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33653 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423173Ab3FUPTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:19:33 -0400
Date: Fri, 21 Jun 2013 16:19:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>
Message-ID: <20130621151930.GB27646@sirena.org.uk>
References: <1371711806-18826-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fGPQ8TN6VVAOY/Hs"
Content-Disposition: inline
In-Reply-To: <1371711806-18826-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77693: Add max77693 regualtor driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fGPQ8TN6VVAOY/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 04:03:26PM +0900, Jonghwa Lee wrote:
> This patch adds new regulator driver to support max77693 chip's regulators.
> max77693 has two linear voltage regulators and one current regulator which
> can be controlled through I2C bus. This driver also supports device tree.

This is fine but doesn't have a binding document which is needed for new
DT bindings.

A comment in the is_enabled() function explaining that more than one bit
might be set (or replacing it with the generic function) would also be
good.

--fGPQ8TN6VVAOY/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxG7/AAoJELSic+t+oim9kLcP/A2HSKJMkWzX9E8Pq/08uE5E
vge2oDezN7ivghKgHnDiTVNIjI1BWvfdFIQh8Vy5bWsyV/WSswqQGiYRiGOL2pvY
vbgLwYnVxPOHOldc++H/hfzx7LANEiKj1mbwpwJ1sxCSqveAnmSDTfzpyJamAuVi
JWbrU0xtOyWOhQlkbRczey0iy7tbjch/w86/1kQ9YyQgYFCZNUG4IwAYIw0zXius
OP0Gy0hYOyRtYL+BvcanZmLILNxi9NdgybwLifxJKkOQ2uaZX3VFZDsrPSBWqnfg
lgFKqPJFiRVJ4XIexJxkd3MEYuUb2/cNXOpGW7OLqjnkWA7ucjk+dac/Dcfu1ZUq
ZYub3Y8WgwLON+8eMSQK3XSAkh8CW5ipaOSn4YBUeKW9bTwT+XkCjG61XIy2aZR1
m+ICboUtdZws8MA+/20IntYKEr0Dbc1mmO2hK+DuZXUzKcbPOJ9NDThTA/c7NYAe
2ZK7bdgzSRxy3VLLf0Io0amaF0MIpFWeJOY7UF8os6R02TKxzZ6NZnw3tqarWhrh
NNwCNMhBMqJYKV9crfws7UoLgHe7QUqdFPMU3pg3kfoSXkgceXlIFhqljXgU5nPQ
DVP221/x2BUxgClBTRcYQ7KckwKn6fXhJdBagBKt+HtnNQHE//hit+JS+rTsFCDk
krVaD5jwZiKfezQxhrmR
=P6yV
-----END PGP SIGNATURE-----

--fGPQ8TN6VVAOY/Hs--
