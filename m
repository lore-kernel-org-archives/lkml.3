Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3L0JCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:02:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:33460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab3L0JCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:02:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,559,1384329600"; 
   d="asc'?scan'208";a="430593876"
Message-ID: <1388134966.2183.144.camel@jtkirshe-mobl>
Subject: Re: [PATCH 1/2 v2] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, davem@davemloft.net,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Dec 2013 01:02:46 -0800
In-Reply-To: <1387901568-1762-1-git-send-email-ethan.kernel@gmail.com>
References: <1387901568-1762-1-git-send-email-ethan.kernel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Jh2BxjmrGP0CuANpMEfl"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Jh2BxjmrGP0CuANpMEfl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-12-25 at 00:12 +0800, Ethan Zhao wrote:
> Because ixgbe driver limit the max number of VF functions could be
> enabled
> to 63, so define one macro IXGBE_MAX_VFS_DRV_LIMIT and cleanup the
> const 63
> in code.
>=20
> v2: fix a typo.
>=20
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 5 +++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h | 5 +++++
>  3 files changed, 10 insertions(+), 4 deletions(-)

Added to my queue, thanks Ethan!

--=-Jh2BxjmrGP0CuANpMEfl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvUI2AAoJEOVv75VaS+3OiqoQAJOwj6KCjLRzr+g4goKjTW2V
pugHj1Mwt3PdsZLp8cAiuR/lTbYnZK39NGYFx0DK70WoXr0tc1XMCJnajSO3AlN1
wJHGe5yiPUZcSfUIDfElhtweBH7wyI4pPOMFxdZJ3wtLUl8ikb3KrxDHytzLeYGZ
hzwRapoPca4ogMQ1lluKDpgMKOWQpSfuQKrfs1VL9F+QMCHRqYizXI+zzrAAnsFd
Toc7YqSHoJEK6mEzXu9GNDbDvvs7pZTEiz4701J6v6z9TQMgMwNioPf4+b8Pdl4N
0ZKi0G0Zj7QQdYU7l+duWp2gUUcDW51KpDCxCRAr0p6RcLnB7nSpex8FQXnicv5J
WNhywNNUdGk5+kT+1JS9sREo9usbByz/DDwiHfwKe/wuoj1tIPbu/K2hE56aox+o
jK794kRdDD776rfcIg8anlNdGot1efvIFS9DjAOGNlJNjMCVtyDvdpWT+JhLIWdY
R3G7apNYNVsFhO9E0HyT7RKN0BpGQmvgHawZgTNloYyxXbZIjZlORUuBluvryxIC
+bxtDgQS1FHHzNoKzME2YfYw4c1IRjUmMr37VFzx0DD/Xfcq1KXSrfzHhoKJQMVb
cXqXNS18gLyxRl6iR7R4iteuCBUh+3tNwcD7+u3mooEhhvdjHXPxUS/t1SmB5zRG
gCyOTGv7gdVNuYASR4bk
=eE2p
-----END PGP SIGNATURE-----

--=-Jh2BxjmrGP0CuANpMEfl--

