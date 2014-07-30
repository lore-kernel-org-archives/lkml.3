Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaG3Wc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:32:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:43694 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbaG3WcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:32:25 -0400
Date: Thu, 31 Jul 2014 00:32:19 +0200
From: Sebastian Reichel <sre@kernel.org>
To: weiyj_lk@163.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSI: omap_ssi: Fix return value check in
 ssi_debug_add_ctrl()
Message-ID: <20140730223218.GB582@earth.universe>
References: <1406681621-23265-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <1406681621-23265-1-git-send-email-weiyj_lk@163.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Jul 30, 2014 at 08:53:41AM +0800, weiyj_lk@163.com wrote:
> In case of error, the function debugfs_create_*() returns NULL
> pointer not ERR_PTR() if debugfs is enabled. The IS_ERR() test
> in the return value check should be replaced with NULL test.

thanks, pulled:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=for-next&id=3fd276e9c0d75538c3b5ed96d0ce36d227fdca95

-- Sebastian

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT2XJyAAoJENju1/PIO/qaR6gP/jYcvE5dzww8fNQ+aIfFGNy0
/4aimgg4psjmbOjYaX6Ngj6zgaqoO3peoH0ERUtKi9TjfL7vMEbZbyZWv8jEqfZK
GiWFoAv6fNsblnHL38z4CPffNk7JOdIx01VGF2mVxQs3PC0u2vab+HWP1/RcablD
PrisVLrhPxa75mrH2tlaRCwpyiQFzipPW6EBFqbEQLe4CE8U6M+1bhAmLeDc52Qk
ksnafuy0dZrFNMfkotkGXNWsQXnWJ64VAyEER3Xltvr7d4Gix5kG6l8MfPPyBRDQ
uY5uPBSezOS/Oyt/2GxmF6gWCT8zDXzhhPTgJ+GgnQQpMetBPnfjYhJHkIaVC9zz
qoYDQsuJNDGwzMSNBmNM3c3Dq3LgYaS6vnCUI7RBW3/Agz1Ut8iSw8TvXtZoyV08
qjeWPS7ys3Fw/+YX+uP8GMmHJ2xhJULfNdDvtO/5V/VheFzjZs1eQjPPYMSJVh5w
sOdNVKa0/kvjWt3SnVB28RCl5trvy1n6IMdcFyZFsVawAyPAZRhvlGe+OutppZb7
AeO6rsSLSz+AIygh6UTojwPYuQWT8Ll832GUVJ+Ej1itg/6TN+6qiWGt68pbBWtH
VHyGTBG1xGkm2iQs7n7BdCpaMQyJKVX1pUPRB0w6/tW6Srb6ZmH/e1Lyg1iY+gsR
daWuLd3Z1td/ThTJuxKJ
=ahAj
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
