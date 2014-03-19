Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160AbaCSNLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:11:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36889 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080AbaCSNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:11:37 -0400
Date: Wed, 19 Mar 2014 13:11:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Message-ID: <20140319131131.GI11706@sirena.org.uk>
References: <1393912018-15780-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJYtPRuVoi7CX1t8"
Content-Disposition: inline
In-Reply-To: <1393912018-15780-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s2mps11: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJYtPRuVoi7CX1t8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2014 at 11:16:57AM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--eJYtPRuVoi7CX1t8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKZd/AAoJELSic+t+oim9364QAIC+UeZJHJ5PM1BGIOGY1grZ
05dfORPkiLiOqufSUbr2pWFDqg9/RciAOi1DtTE3rP1enweYzMQ7tTpFRr5/LT7k
+IbpC8GlN4Nq8QWrrADvmOyXyi2iuMpp/NCZSsaC2dFFhRlKL6p9rUOOqaECp1vW
+wpFhnr+yOlrAW5/lrEfG+2/zJDvMqRA9ZwJ1BX7RMt1mK5AhFlT1PaPiZQMQw3C
w6xtJLtj+a5sPgyBxvaMI75mnBTqwHdBdjklGlEnEAqLd8I5bmI6vJqde3UOPkJ1
tbjOcv3AEbs8AyBgZORvh4344V9f8s/A0wR2/MsKlzk9itxSgCWTNVKLCF9qp+8B
62eEDdeP6Kzzmo+b4ADhnu95vPGvx5UY/VpM/oDbENUOA3iJhWv6JoHl7DwIxkga
KTec3Lv+F30EAOGB2ucjnoq7+QSzcQDmt8TK8ewh8PZMc+f6WxrMa+sL9Wzs5b/z
Zey/ZmNJhy65f7ia+3j1IqUIpHYl/t2hSx6GA+kw8E/oWcXDBVfobRABYG3Txqbf
qD0uvj5DWwRTRFYvgk+kZo1PDSoNBr2qwXpL0dHTWLSbutVhtASSTROiX1NlqTfU
+4s9wocMqgXrlbJNsDF2Bwxs3TfPK+50AM5H9mbLcfIFE7yQ2r898Yulf6quzp2o
A376oj8jCCq13Tw0UlU2
=7lOJ
-----END PGP SIGNATURE-----

--eJYtPRuVoi7CX1t8--
