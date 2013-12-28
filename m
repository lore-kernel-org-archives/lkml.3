Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3L1NPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 08:15:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:34696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab3L1NPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 08:15:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,566,1384329600"; 
   d="asc'?scan'208";a="431015279"
Message-ID: <1388236538.2183.190.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next v2 06/20] net: igbvf: slight optimization of
 addr compare
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 05:15:38 -0800
In-Reply-To: <52BE6CF8.5030806@huawei.com>
References: <52BE6CF8.5030806@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-t0/fUJ7RPWcAN+vVqjrS"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t0/fUJ7RPWcAN+vVqjrS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-12-28 at 14:17 +0800, Ding Tianhong wrote:
> Use possibly more efficient ether_addr_equal
> to instead of memcmp.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
> Cc: Don Skidmore <donald.c.skidmore@intel.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/net/ethernet/intel/igbvf/netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Ding, I will update the patch in my queue with this updated
version.

--=-t0/fUJ7RPWcAN+vVqjrS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvs76AAoJEOVv75VaS+3OF7QQAJGjxd5i76w3ja7dL0WlwhY5
f3F834YSKZrhTq1jtISnKzkt5eseqylvEyftoAblGm+CG+kUzI8spLzTvySfPdLY
hri+Qfg9q7xNoiKdcbgP1/mZ3G0jpqh/lGq6Mni8S+G6XtjRFUIm8pgWiH1Q+KQ2
++33SKVM5ffO/yCyLwMtys+/SlvhvtzMFuW1nEqBk2okG07o8i5vgE60L57azm/p
ndQsK7ZGbkBwX/9kJfzCJXIxUAM+O7j1xdt006PKhiSkmDNVUlK/wjqfY7dWJuex
VCCwUf1KBZacz2mC8ENM0uvqmzIQyxq6cRO021EmbOqBFWvHgUHOI5Poa3qxhADh
DHmKYaIEURiilpSOT2CkYF/T/RdEjQxZlIUDrjKbYOJD5xt8bIB+b9AhWZ5LC0ms
Th6jJOoB0S35Vo2r5ZHh1gjbsqmdBgsp2VyC4FOrafM+5FzkhUpC9acezYBV/9qt
z9XAmrQg+sPEKf0nDLlHgwxDi6UTvOsZEQZC7oYLDDO+fiF4ULgJfJpmuSZV29Q9
zsekBrjwvR/FMOMhFTGLaEPzxXxLmgcb+XSwS1AnZOssXGTr0zIocAxxnv5Ul9gc
EsIh6jzEoRNXkOpy7CAuz4DceUxKDpXQHzTATDclSUQX7YBj5fMLV1qg1jdiGCBG
hKpBwQQRGmirEGoydCfm
=GMLg
-----END PGP SIGNATURE-----

--=-t0/fUJ7RPWcAN+vVqjrS--

