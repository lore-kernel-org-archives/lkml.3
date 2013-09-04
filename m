Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674Ab3IDJwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:52:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35799 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab3IDJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:52:22 -0400
Date: Wed, 4 Sep 2013 10:52:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Message-ID: <20130904095216.GR3084@sirena.org.uk>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UN41tlPsqEEbq75"
Content-Disposition: inline
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/9] regulator: max77686: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5UN41tlPsqEEbq75
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 11:07:54AM +0530, Sachin Kamat wrote:
> devm_* simplifies the code.

Appled all, thanks.

--5UN41tlPsqEEbq75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJwLNAAoJELSic+t+oim969AP/iTZMHLtp5jf3I3R0VdaykvE
nWSCfDxu6Drj9w36lN6QZPjbz6Z1+Ke39gSk1nrbwnEt8Y61QTv+QHflmY0DOE0g
ra/TUJTDpKlfEPNwbG6cC57EKmM19amSGGyvWwyXgf9uJfSB44b/dQGAmj2Iikcp
aP1MaecNC27/AuUmamS4JGPiIlgJz+5lp3Rb8M/rBTbsrvzPd53dtgG/i7OZUjFy
fUI8EobVLClQt9c8Y+TmNXHTyV2KRLjEB9sogYxFydmfXpHStj/BXH22bCDpAW4E
JFqtG1VeEhGU5FnZeFoSTWxKPuudW5xefb6j8++0nnMhpfkBadrF4usVcLzCnNpj
a77+7DA3xjYq3t3WrYguuCYMzmMyEzDPzs+sUDJgaLA/hzZVLlO6K8xviK8g4MKY
AmPy8eKg/y7J3C0vCrWdU9Dk4bHB9e6QXM8NUFs0qgrwLAv6ua84p4hyQIj688WQ
DFwifRmJnKdhE71EjxD3R2AKX8wmlXyUiF6KBXVOV0RH0iTle657QarL2LJuI5Q2
K0sz+aBV7xa/hm26MGq0omKn5607QLOLMOJLGTSnf01c9onS4JdZDcCAUbm0FgrP
vzNvxMU9Gc/mA69SOOLuKXz/jdTkC2p7hnEUEiDM5Zyp2iCWOytaDfeg5Xfx/Sy9
hmr3objly2MpXVkoRSbp
=lZq7
-----END PGP SIGNATURE-----

--5UN41tlPsqEEbq75--
