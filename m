Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3CEBfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:35:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:5388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab3CEBfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:35:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="asc'?scan'208";a="293607590"
Message-ID: <1362447339.2183.5.camel@jtkirshe-mobl>
Subject: Re: [PATCH  RESEND 3/3] e1000e: fix accessing to suspended device
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Mon, 04 Mar 2013 17:35:39 -0800
In-Reply-To: <20130225051911.12689.11167.stgit@zurg>
References: <20130225051010.12689.28611.stgit@zurg>
	 <20130225051911.12689.11167.stgit@zurg>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2tFXg4VWXzJr0mkRc+wC"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2tFXg4VWXzJr0mkRc+wC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-25 at 09:19 +0400, Konstantin Khlebnikov wrote:
> This patch fixes some annoying messages like 'Error reading PHY
> register' and
> 'Hardware Erorr' and saves several seconds on reboot.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/ethtool.c |   13 +++++++++++++
>  drivers/net/ethernet/intel/e1000e/netdev.c  |    2 ++
>  2 files changed, 15 insertions(+)=20

I have added this patch as well to my e1000e queue of patches.

--=-2tFXg4VWXzJr0mkRc+wC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNUvrAAoJEOVv75VaS+3OMLgQAI8K0PLZX4Peter4DNGnXQoD
2VWiuhtq0zbgAZ/v0MnsP+c6nUaSOoNdxdMWhLlkldXJFrI+BLOxC3umha+2zJUU
CXltHBrJ2iXEpE+Rwv6U3bMuDPN0mBAgiKQcetUqKFroIMPmoAKeU5GMj+0SOlau
Ll74FiCdwXaB7YVbXmyJwOtSkPlT1TXVikozLzDTGdnkKeARsOv3DYtjqpshkD9c
nbzrItKExfLp/mme16Eh/hZu+X89tzF/7GBIr9+foE5d1cegTOPeXce7qPXEGAsd
C4tcUpdNLao+wiyxKVMRzqolbv/mt5jNFnGrjIxFIPXxgOSF647wIGXSIp5OJwvr
Ye+u4S2AOlDvXJhuPDdDHC8qS3Em+6TxnbjB1SDByi42JBZMNZKS6mFHfQuN8kwC
1G+KM3lvrgPr+WtgGz2xjic2Opd5+U9Erkhvdr7wvVRK/s0m8uMXV1jMOGH+VDV/
dZSjwl/9gtLts8ycZ4b5y57KYsZ8o3YK1BTT+rEP8x+8x7PjuP6usWdTx1BWHtMd
dQiteisO7JybXxFqNFreddISnqIZ4bE6wYIXvUhrl+ORyOcXFerbeAlv2iQ0k7v6
HIIjAz4U2ffNGWZhU0+1YE/M+qpXJGuK1SHRC3fRrnKz27yVZ5jZnNR88qEu5xRs
3a4e+UsXCdcs++d18F3M
=zPEt
-----END PGP SIGNATURE-----

--=-2tFXg4VWXzJr0mkRc+wC--

