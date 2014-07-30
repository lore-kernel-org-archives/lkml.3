Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaG3Wbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:31:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:43633 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaG3Wbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:31:31 -0400
Date: Thu, 31 Jul 2014 00:31:24 +0200
From: Sebastian Reichel <sre@kernel.org>
To: weiyj_lk@163.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSI: omap_ssi_port: Fix return value check in
 ssi_debug_add_port()
Message-ID: <20140730223124.GA582@earth.universe>
References: <1406681600-19741-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1406681600-19741-1-git-send-email-weiyj_lk@163.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Jul 30, 2014 at 08:53:20AM +0800, weiyj_lk@163.com wrote:
> In case of error, the function debugfs_create_*() returns NULL
> pointer not ERR_PTR() if debugfs is enabled. The IS_ERR() test
> in the return value check should be replaced with NULL test.

thanks, pulled:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=for-next&id=c2acb7c4d566a1735e255acc7260e1dec6b9a7c8

-- Sebastian

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT2XI8AAoJENju1/PIO/qa6rYP/ivZZqPbrBNkrfdvKfq58LUw
dwQ9UZYLhIYfpUUlcsWgpBzafP9RtIvdLvmFhv8UiSbN7yEFM8Lqg9FdnfQksXW3
tYtRw267DOKdEenxeb14e0jEyGmfLW4I05rt332Mc0EIfaLZnao0mGQVl3i26jrP
hZnbXZNZTyLWPbMJCEXmXonWUv6GoKtjdyrObpPAFmgyzBwHPCDLpmrkwh8U1wcx
XyaiuZDU6WgL/2oPmg4lLIl6bay+NCsU/FKg91lUNGQ0qkLIiODlp1gI6UM43a29
Ly2iBrVjGDJelTpTRx8vo0koD7kDOI1u3Q0pnCLMEQTLPkDXWdv8zn3KlaMw5YcT
V1nrLujVamIgdGEBgPqw1+z0LU482DHWzBfdwOFJf3zd8uUeJbkhaS4GY7FH+YOx
ruiYcml2oj5BO9vYTtBiE+2g/7CNEXXiUEQb6fNpoX/xsdcSdzmBquKZ/FUyTj3q
TLbSIv5mkMwJPx4zQGofSao4q6rO9UjQ7XrV90BRnYjOIWz/fTypZB9BhFcWPsHu
TCFdwi5OOYDCYUic5vxD1YaEV1CoCtQAUNB2SPlGDsqo10dwGw9reU9vTFp+gjhg
FavcGQj0gPl23xKJU/erCSskvvDJqzMFVPWi4vU2siWjbQra6BQQQPb65r7bSmjO
vFQ1TNZ0LEpuiHXaZUHt
=XZVU
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
