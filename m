Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3CEBdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:33:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:28306 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723Ab3CEBdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:33:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="asc'?scan'208";a="294806723"
Message-ID: <1362447219.2183.3.camel@jtkirshe-mobl>
Subject: Re: [PATCH  RESEND 1/3] e1000e: fix pci-device enable-counter
 balance
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Mon, 04 Mar 2013 17:33:39 -0800
In-Reply-To: <20130225051903.12689.77185.stgit@zurg>
References: <20130225051010.12689.28611.stgit@zurg>
	 <20130225051903.12689.77185.stgit@zurg>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-G4Gatqn1MRwR3rAkgwUN"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G4Gatqn1MRwR3rAkgwUN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-25 at 09:19 +0400, Konstantin Khlebnikov wrote:
> This patch removes redundant and unbalanced pci_disable_device() from
> __e1000_shutdown(). pci_clear_master() is enough, device can go into
> suspended state with elevated enable_cnt.
>=20
> Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in
> v2.6.35
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)=20

I have added the patch to my queue of e1000e patches.

--=-G4Gatqn1MRwR3rAkgwUN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNUtzAAoJEOVv75VaS+3O8nMQAIfptFBnAtAUXv/53xZ5k/S7
XkUWeMHm4rzco9hpFI0G0Ybz6ZUISKi4GeIb3zx/zbsYSCw8NeiGLHPQOBDbitO1
B1477iqsqmH0qgWxa3kzaiDOT9SIwmAQ2jXhDPGUUZr50d0VSNH4Pn+hG85DU53u
meCslLGT/OHM2VFXcE9KdZU0S7ZB3fBBT5FuDr8OoXOPbXshNryGI7KifCfAth9n
bmEHLsCXgQ8zHIaHWM4AToIzXcyfq/UmQE//idEBLCt1J3HNhwIbhfeGs2CcIFpG
X6Z/9/AyNL/QBhlMGsabyy0njY8v9Cinwc6Yz6w8LxahMxC7evBJ6AE62Arg2exS
bo+sFhJ0fJcTXXZM8AoEIaUOUFbXv2Na311EBNBW81/w+dPShiLBC/qK5RvF8+5l
ujpXchNwOMWSoGXDCx456rY2reRmlv5YbjWOAMqug5xZabmHfgtOgS0059Q9us40
p6YUNkcEUcmexOLh/k65YJ9zAAz6JGMjpcJ5L4rlihAflojHyB1fr/3i4W5C0DH6
JmyuHbDNxcs0VeBM7AIbN08pbzvYxxyrjEj3Rj61mY9kDpK0p3Em2Ij6xaIT63yi
2g8Qj//kN9WUIJF4+dLLRkfcBZiKGHDzWnkMeM9BRNv2/mpVJJ36qFoVTb/jQXEJ
18Vg5yHHz7zTDoLd+iSm
=3Wny
-----END PGP SIGNATURE-----

--=-G4Gatqn1MRwR3rAkgwUN--

