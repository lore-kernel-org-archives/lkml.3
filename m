Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbbARKz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:55:28 -0500
Received: from mail.kernel.org ([198.145.29.136]:36934 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbbARKzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:55:23 -0500
Date: Sun, 18 Jan 2015 11:55:17 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: max17042: Constify struct regmap_config
Message-ID: <20150118105516.GC11147@earth.universe>
References: <1420447817-4262-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1420447817-4262-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, Jan 05, 2015 at 09:50:17AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.

Thanks, applied.

-- Sebastian

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUu5EUAAoJENju1/PIO/qa1GsP/0Q9lqklWni26ZpUEN6RKsuZ
0VQHa6Qr9U0hhrsf2Z3+FdWgUViT5qdbPfjWXNincnfI1Wu2Xrye1RcNCrUDJQku
/k2OcFEl1Ns+u4e4yr0UWrsdtLTTFQ0fYX6Jh969WjnD+u2xmSRGK3J8szk7ruty
OTmneFmwiLEJtXno5chtrBfC6lZwK3Ck/IT56tK9UYvtMHWEnK9hBz2683qSAhOr
otM/tuqpm5Fe40L6GsOhTJv3QmrW+56VFArylfagBHX2mZj2yUV5q51fMVpuDBu3
vW9rk9o5c/0pSwpOkpeOATMDj51yVU45N0CX06bcOHcbZEhwPpd2JcPPfiGfu7am
jgcwRp4k4xvaUWIW9/Ruz2XfZRvH7le6ChsBTxxfwpKD9ekO9QMvxfPxtV1IDz6M
mRC98hdhtSJzNcU8RYfjFvH+kdSEnb59fKnPQMAimS25kGl6wNvESUpUMGuAVQBe
wIk8qEJa9IXN2foeTSmhF4Yb8OyIThG0kgyF1tMLLBpUSuwoDFJh0af76HSpAAXw
x5JM7TiTQMn2unqJ6CD8CNesaudt1xmEKPwNvRehImdE33Sekue1ygfapACFoiXE
o/GY+uWTnGc7jv/CM738a29V+dUGTVKKLsj/YGZLXwNFv7Ag1i1Qk9qZKH0jgqYO
htaphqu3myds9SdQshsU
=RZSl
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
