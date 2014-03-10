Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaCJKLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:11:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaCJKLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:11:54 -0400
Date: Mon, 10 Mar 2014 10:11:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140310101143.GP28112@sirena.org.uk>
References: <1394350032.19772.1.camel@phoenix>
 <1394350171.19772.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HNePlKHf6vuaTOUD"
Content-Disposition: inline
In-Reply-To: <1394350171.19772.3.camel@phoenix>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: max8997: Remove unnecessary **rdev from
 struct max8997_data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HNePlKHf6vuaTOUD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 09, 2014 at 03:29:31PM +0800, Axel Lin wrote:
> Now we are using devm_regulator_register(), so we don't need to allocate *rdev[]
> array to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.

Applied, thanks.

--HNePlKHf6vuaTOUD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHY/cAAoJELSic+t+oim9QcQP+wes8oXJXvTe8QfkyBvlAW6D
Xvhhm+0HhW0MvBJbx2Tb3Tdue8HEsdWGlGmtVAzFkLA55jeP1ILvwU+ZvPG1qfnK
c/BEDj/DdOoNh4gYts+7bav6WNJwUiupiQEzy9iMCrvg/5/MZOvN/y+HuNpUcwfX
up48dgknj8mRShx/OgUcL8biGgULW/Qimj/NnH8ureht5JQEeUtYXB5llK49EYYX
stUD3FUyxEhNGvxvGVDmrocWemvHbOjhY2bObZ8K3S8+R7lncuxIG9kCIP3B30sB
QC9tf3GZdTesQUpgRYLAUkfHmEKemyjYWmxU5DB/oFzY04If3lNkng0fqcabEUp/
rRNuGfxc+SX+vZDlxr2uNiWC23N1prQE6BUHre7VEe2Pon4W4CL+Sh1WL5gi/LBh
eP8lkSLFzCsMOMfSLSUlADN74huc4VfAcHdQOHKerWOb9f/WLfXDNMwbvr/bqzY1
eMApEXD5DzEibBJxEfYf63/kzLPowf62oaIJn8asX/h3JJUUE9jcXtmhRKpkzqMM
6XSpsnAwiZSeQWUdTL3nz02y5YjJs/nlPqUiJu+sA5Ge+aqwCsujGbmyNJid+Scg
m/+QA/oTHpQNpoVPoEyNP9AWYY8IxqtwOb1T1KH6bj/f5iD6eORSnbbCjYWYe4Cv
JwXG0tcOxQDvZmbisrzc
=iaR4
-----END PGP SIGNATURE-----

--HNePlKHf6vuaTOUD--
