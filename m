Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3AMXFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:05:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34856 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076Ab3AMXFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:05:02 -0500
Date: Mon, 14 Jan 2013 08:04:58 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [regmap] [RESEND] Add provisions to have
 user-defined write operation
Message-ID: <20130113230456.GI5041@opensource.wolfsonmicro.com>
References: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
 <1358024054-9895-3-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCSxeJc5W8HZXZrD"
Content-Disposition: inline
In-Reply-To: <1358024054-9895-3-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dCSxeJc5W8HZXZrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 12, 2013 at 12:54:13PM -0800, Andrey Smirnov wrote:
> This commit is a preparatory commit to provide "no-bus" configuration
> option for regmap API. It adds necessary plumbing needed to have the
> ability to provide user define register write function.

Applied, thanks.

--dCSxeJc5W8HZXZrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8z2SAAoJELSic+t+oim9OeUQAJYx+UQ285m7zBMeyG+giEWU
1EnL4q0eqh5Bzr9gRtw/IGJDkrINWkWfLJXL18TiiyUHbNyL6hBOC6PWKoeLDs+C
s/2Kyl1I3DRwkWqMlS0WX/s1x1zSWzeoiYEopyNGMOfXLxajZEN35VohNWHJ5Hoa
vUmNbaVevtSqAu4khQVo17WYveu427mugP7ZOco9MRRP15d3ZJSz+3T1WfbUDPjC
+WHCMEyL6pf+AyCwm45G7jK3DP8ghOe40Psy6vQ2id5bEDbc4Vt+5Lz8THO3urg6
CCPu6EQE2frhtbR1zgxiOyrG1hiN8N3kTY5/mZtNu6REdQP93Yd7Lq/1W0PfqCB6
OvBS47ccanLpi7IMBXislMAPVBuaMVma7fER9Yv95uFn0uayPZTvg093tqINNaLY
KGWz+Hm3A4LBacQlGbSqLbsPkM4oN3AXa7YpkEzZsiplu33bh6ouHe2EkdWHStz+
yv6NH3hw1RqjxTRq9beW61w5MV2AT8bS2YRlJ1z+7X+d6heRoemFfXAN9G2Ni+SL
w/Dd6kfRvRY06b69dsA3W5Kxrh0HKak/BEZfsOw/JUuCJRoLPFz6eCKIPb9+kSrG
/MdoJdqDHYwP6VCkmoZh5ngVHOpAnIRhp7MkuKRKScYcHEq2GmICcbu9VRLs5Rt+
FNedkyXLNL41YXMesATI
=Tmbr
-----END PGP SIGNATURE-----

--dCSxeJc5W8HZXZrD--
