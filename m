Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3L0JtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:49:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:5381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab3L0JtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:49:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,559,1384329600"; 
   d="asc'?scan'208";a="458338113"
Message-ID: <1388137743.2183.151.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next 07/20] net: ixgbe: slight optimization of addr
 compare
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 01:49:03 -0800
In-Reply-To: <52BD22BF.70108@huawei.com>
References: <52BD22BF.70108@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0jDMcv8i2aUI0N+A8kzu"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0jDMcv8i2aUI0N+A8kzu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-12-27 at 14:48 +0800, Ding Tianhong wrote:
> Use possibly more efficient ether_addr_equal
> to instead of memcmp.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks Ding, I have added this patch to my queue.

--=-0jDMcv8i2aUI0N+A8kzu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvU0PAAoJEOVv75VaS+3Oi9wP/jSFVgwDTUbJH7HX+zKbGgGr
ZNgd+2iJXABOTh3pCgizF+rKzIQVaLuk4S6Vn8SkSx12tugxMMoPt5C7d7zQOzMD
lrpO7hGjMG+JHPaJCQWOVli200jUO+9zQYTKCBmzs5pCoGAwy3pwO7Zq67o/wBNU
lwDGdBxyatk2hIcMCzlW9mQluosS/TgLy3VfXP4x6nIFx4lwbjCZ613c43qqiqSh
BmhcE/3iTDgouT+gwLjEKvmLG19yEdzDedQ2SK7jSZg43Qcrmm3iu8QM35DMvRmQ
w9I7uWw99MuCiRf9MAe+iYiVoaPign/5rEm2+Cwi6AIpw57JDmcN/kGXZHEuddYx
M+dBuq4diJoGzOjfSwj6PCzksFJtpHZwu+uu9sBxkhPl5ELkjHY+6ISbauHI+Xy/
757CNWUQLSW0BCoDm09/BiEZOZssaf9p+Gm0hU4O/4JnbEMFCG2b2mZIxPnbJgF9
nRcCiZ/WmzlsVkaIiIzzVhTbSFr6WtoAyPSmKfzSCNfbvRE5dtClgau0ZHEuU5Cs
sGWzTPW8hIqfeiwndr8rvwwbYRSg+GOXLF4IpMZfsSXoR6QGls8Fv/9/iSCt62UI
OQeyvUFKx63R2sA2AG3Pk6jjGMcZ9GMB5pGuoJrXQ6CndECGTF8CRIhyfvqHoV2e
p8L/lfXstboSAVi+7HjZ
=SxhN
-----END PGP SIGNATURE-----

--=-0jDMcv8i2aUI0N+A8kzu--

