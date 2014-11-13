Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921AbaKMXmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:42:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:28239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359AbaKMXmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:42:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,381,1413270000"; 
   d="asc'?scan'208";a="607548519"
Message-ID: <1415922116.2454.34.camel@jtkirshe-mobl>
Subject: Re: [PATCHv2 net 2/2] fm10k: Implement ndo_gso_check()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: netdev@vger.kernel.org, matthew.vick@intel.com, linux.nics@intel.com,
        therbert@google.com, gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 15:41:56 -0800
In-Reply-To: <1415921801-10452-2-git-send-email-joestringer@nicira.com>
References: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
	 <1415921801-10452-2-git-send-email-joestringer@nicira.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xXioHg8ZncoHGXFeolQI"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xXioHg8ZncoHGXFeolQI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-11-13 at 15:36 -0800, Joe Stringer wrote:
> ndo_gso_check() was recently introduced to allow NICs to report the
> offloading support that they have on a per-skb basis. Add an
> implementation for this driver which checks for something that looks
> like VXLAN.
>=20
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
> v2: Reuse fm10k_tx_encap_offload().
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k.h        |    1 +
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c   |    2 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |    8 ++++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)

Same with this one as well, thanks Joe.

--=-xXioHg8ZncoHGXFeolQI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUZUHEAAoJEOVv75VaS+3OOn4P/jWpwc0mqsNkg2EvzX2mOKF9
I2Hl3uHidRnCIVpA2jdkTaoNB59+ZassSuvu9xReFyRvGvSvGXQDR5R1uIg1tzaE
eB0qvUCvS/0LXkcYFyi187lHX9Wdz9pzbTFnQWYK1k4ggdUiHfJGzbIxASGnPbUw
aPI5xrn8pL4I0svCxTEgN5T0s9YS+xSdp5yiiK9SBdvVPqqVWWjUgOHhbOj70G6x
nR1SX8Rt3VTCVbR/cbzCVAeCOcLBJiTo/pFl6Lc1FbQomUORFO6WAPy6hF5Jomfh
AbEwugh3skpqO3PHgFTXR/7QqO7PTjuCXBSgK97aEc7HCygcOUSFQX/JJELKSCdR
xh5TMQAvnYrQP8NJZ7Jq8dh1aXEkfRRH7qmKVZY1vjVAILV+mPN8RobLqzz/RWyD
5XHpYQnFpiFltE6viOKcj2rCP3ISvF0zZcx1+KCggFCK129EFyToJCWPX/hePUM+
2+D+uVX0axn2xE2YPQBqJUEmmTZDe5qsaovNw/27LoA5oGm5YeRdgKiOIbltpr9t
5o1LxlbmTbPo2Yr+G3pyVmWnlR/TI1pPWIAjGplPZPZiyUVMnGC9eIpGeWwkIP3h
ckIPoOr/EAFk+zs4E9aWQY5g/ExeWXflOjGrbg+Xp2MNQW2g1Fj3D2CIQL1KuTxm
giVgkXGXDe+5Pnf+hKMC
=Kkfn
-----END PGP SIGNATURE-----

--=-xXioHg8ZncoHGXFeolQI--

