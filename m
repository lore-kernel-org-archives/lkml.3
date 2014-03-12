Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaCLUv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:51:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:33174 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaCLUv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,640,1389772800"; 
   d="asc'?scan'208";a="471182200"
Message-ID: <1394657468.2167.8.camel@jtkirshe-mobl>
Subject: Re: [PATCH net-next 6/9] ixgbevf: Convert uses of __constant_<foo>
 to <foo>
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 12 Mar 2014 13:51:08 -0700
In-Reply-To: <6477c916f14711f9f0cd02610a8b8a3c1804a83e.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	 <6477c916f14711f9f0cd02610a8b8a3c1804a83e.1394644825.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A5hwSd72h4MGE5m+tD2V"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A5hwSd72h4MGE5m+tD2V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-12 at 10:22 -0700, Joe Perches wrote:
> The use of __constant_<foo> has been unnecessary for quite awhile now.
>=20
> Make these uses consistent with the rest of the kernel.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Joe, I will add this to my queue.

--=-A5hwSd72h4MGE5m+tD2V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJTIMi8AAoJEOVv75VaS+3OwLsP/Au5Ktp6VC5RcF8JkClN4ez7
yHe5nopui9oVv9gpRtl/jgZ0jTHAtw33wKv92aYyx8lkgkygZWt9UKff2Q3fD03W
0N66Pv6Tm/VDSer2fQHkoHRsDubmKi3nwn5bFI0u65wiqqgSlE4Iiqk+Nt8U/Ue1
FXtbMxm3pWoW6ivP7yVoG1eYHvXUoNKbcFLb2MfqDfCY0R6AkWb3zdGrHLcjaDR0
SAMp7c5rtx7wp8nLCI+Kb5jFplWXK7RQVXqqOLVb4uvSNdVVpteDJfgXZC3YV66m
4O9B5STcIgcBXEq0y2sPhiNmebiP5w02X5o8+G5qz0Cfnsv1MVcx28MAcnPX5jNy
fn8H6MBjNlEfOQ0lwU7Y1VYnvncDdZZ1l4gLVVyGTz8YHi4ZP3MIsYfFN02ZKbCM
ywxXbIL7RxA6OzABsDjD9OWcH3RiMG6MUzMuDktH7ifTjR+3ZeXjLz5yemcGS01A
PVNgdbYDDXEriQD/RUFzQUqKJ0qEHLuUE3p5fqf5vkBJdLmtUOkn1yjdIIHClUke
JhVI3sbtExleKOfL58Vf2JH5JDRKrtw6oBPTHcxKb8I3UhA+PSAvM+w4F2Zyx0aP
AYRoskP0MRHiwFezZwy1s64OAN3136UYYgPcBEBPcAny0IA/dWvItyAKyX+fbHXT
gyYuYAEm7lYbagO9bcyk
=OVNH
-----END PGP SIGNATURE-----

--=-A5hwSd72h4MGE5m+tD2V--

