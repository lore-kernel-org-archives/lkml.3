Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3FLJyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:54:08 -0400
Received: from sauhun.de ([89.238.76.85]:43969 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3FLJyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:54:06 -0400
Date: Wed, 12 Jun 2013 11:55:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Libo Chen <libo.chen@huawei.com>,
        guz.fnst@cn.fujitsu.com, sonic.zhang@analog.com,
        uclinux-dist-devel@blackfin.uclinux.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
Message-ID: <20130612095531.GA3008@katana>
References: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
 <CAK9yfHx7ifnWjKCVc0Oju-28PdosF81OpVC5S5Vdj6hDSnfQfw@mail.gmail.com>
 <51A451CE.8070801@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <51A451CE.8070801@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2013 at 02:42:22PM +0800, Libo Chen wrote:
> thanks for your review. I will update later.

I agree with the remarks from Sachin.


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuEWTAAoJEBQN5MwUoCm2p6IQAJYwgJ1Ggw/roCY3YcxMu6pn
rJzcMS+6MHITIKc1WqH4fOVvrRpyIOmTMPj9Bp+zfXmSy3B38ynHxV0XVkNVyHbS
wIfBeHKfo9CsS3Qdz7gs+9Nt+5J1+j0DA6712yXDzoLyqWtXokd0B3MIgqzKVXgU
dW7k1w/55YkZrvcB1adgCrJMUWynsQj+MHIVhwd9re6Jpf9/neuaSzr+YpfsuJ2n
EDo1Jsc6aZ1eDHY6xQ0Cyasb7gAWWybAkemMVaJEH+GMdxBwqWqwvf1G0D1ZlqOI
wokgZS34L5MT33Wg+GzCofVZMBA4cbynImayNKJT1JtiwKcZvlYLGsoxvZrmCYBR
MmCOf5PIO9dhLWWHi/2yickQJhgF/LGy2tg/+nN8Vdm8vc7fF90ofVBT7LE5WQea
6tEu27bPjg5AceMkOLtQpIOZeWuyKFU2M5JhZrZYxgnpFhibB/LzppbbuMDKbENN
tRyEAdGUUJT595700vMJqca1gafA+paO9hp6rZOZBBISdptHOXEiQt8mZFu93HPt
sM48VVy9NCMNLp234x5l9KR+cgc4A4ohycOIyeMmBsBPWXa/55q6vIZamo5UCtaW
mPp3zrTx/MiDRYV9u9cOrZ8WB2f01P+i4p3HAuK7bOW3YDgMT4IvfhYrVuq284uK
aSGEQjO6PEFeMecE0xF/
=Wxk8
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
