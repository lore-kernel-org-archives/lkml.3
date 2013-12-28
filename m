Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3L1NQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:16:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:31141 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab3L1NQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:16:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,566,1384329600"; 
   d="asc'?scan'208";a="450774184"
Message-ID: <1388236584.2183.192.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next v2 07/20] net: ixgbe: slight optimization of
 addr compare
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 05:16:24 -0800
In-Reply-To: <52BE6CFD.4090403@huawei.com>
References: <52BE6CFD.4090403@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-P7tuZEL6HSYBcQ0j9lO6"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P7tuZEL6HSYBcQ0j9lO6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-12-28 at 14:17 +0800, Ding Tianhong wrote:
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

Thanks Ding, I will update the patch in my queue with this updated
version.

--=-P7tuZEL6HSYBcQ0j9lO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvs8oAAoJEOVv75VaS+3OGX4P/RrOfivPqLRPw4STa27SxEMt
bvwbEQ9fGwhT5KZq6tBj8BDvesbXVWx/5niB05Y3QFpp7I26OMMKgPvhefl2n4qw
9SAQd8Ytjsmc4FdZ3md2la0v5iPtHRIcTQXk79uIUrFTOP1xT+3TRgNsHgojZyAw
rxN6NYF4D0Ggb64bAxfRx1VctTE5v7TG65bH1tNp1UItJKU6TxPdWcc3r2aVvxXV
5O5NPNB1XBBkE20LqOwCA10VK+MpZ8E2lXiX4x7ozhOFr9VIXohmcEBf5dp96JML
uPf1JRFedJyWHcRjzV/kaTIsKOs2TX4INxhJ2b4GRGQUarvOXrJwchE6bKbAJkTL
TRV0ozGNQsar7tG1scidIKIgPTLOnL8+Ts05jqt2sWCfAhisUKiNjD9lIFo/A93k
AGWPeOXa35lxhQtLh5FqDYJNXwXpPWFCaCP26Bmiw/SdvEa6NkH1n0HjV+S0o29X
WQtWDNdFgedilvgXMvYVqq3JSISz1r+Ykbixeb+LcZrGeQgRLU/5V93jE3idz+Xs
A216dgxrPySDHD+DINarR8CSBgJTFyyjmlvHQwYlR6PDaIRUr0lT5umt0oRieFJ0
vMbGRvNPMzPwOLx897dRvE2lAi21sW7KvBauS66J2VTVuh/lLeg4yYPeRnkFU4K/
Z3ELDDHGD8r5s949KfWI
=ykeH
-----END PGP SIGNATURE-----

--=-P7tuZEL6HSYBcQ0j9lO6--

