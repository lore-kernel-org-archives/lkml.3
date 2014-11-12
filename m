Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaKLPF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:05:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35083 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKLPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:05:54 -0500
Date: Wed, 12 Nov 2014 15:04:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141112150428.GL3815@sirena.org.uk>
References: <1415712171-20951-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWtcfo9uJO/zxEv7"
Content-Disposition: inline
In-Reply-To: <1415712171-20951-1-git-send-email-laurentiu.palcu@intel.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/rockchip: remove redundant call to spi_master_put()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWtcfo9uJO/zxEv7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2014 at 03:22:51PM +0200, Laurentiu Palcu wrote:
> The call to spi_master_put() in rockchip_spi_remove() is redundant since
> the master is registered using devm_. This patch removes it.

Applied, thanks.

--JWtcfo9uJO/zxEv7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY3b7AAoJECTWi3JdVIfQwcIH/3gB8d44Xt2tAViA6rn3AHlY
6IkmEB1rWzfKvwTnHjlBGUh3ipeV5Jht317K3U0Kphh9xmrhiwqJUOsbTY7Xiz1z
cVTdLHJ87JQ5kqdNPXZGlqykwlSR3ldIslXh9CEvZ2UKEXIO0M+eddS9UMdGEitz
5xAs2+pgw7wkHpt1C+0KUu1xSsTz016gYMnj9KJEo+xBP+U4VkwB99rnJNMH0L8t
My4PZuK0EdqBofGBmd81cvhXBg3WxEp9/2r7q0eLad++s7K5dbR+WA0ccq/wxCVi
Q8MoghM0DuvYm2wXDtEkmZCderynzepxq+qTO0lBEioIQWOUuLHmYymBfN6x8AA=
=POc4
-----END PGP SIGNATURE-----

--JWtcfo9uJO/zxEv7--
