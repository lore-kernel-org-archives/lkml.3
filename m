Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaKEMei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:34:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:26994 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbaKEMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:34:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,319,1413270000"; 
   d="asc'?scan'208";a="602702110"
Message-ID: <1415190872.2420.55.camel@jtkirshe-mobl>
Subject: Re: [linux-nics] [PATCH net 3/5] fm10k: Implement ndo_gso_check()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: netdev@vger.kernel.org, linux.nics@intel.com, shahed.shaikh@qlogic.com,
        sathya.perla@emulex.com, amirv@mellanox.com,
        linux-kernel@vger.kernel.org, Dept-GELinuxNICDev@qlogic.com,
        therbert@google.com
Date: Wed, 05 Nov 2014 04:34:32 -0800
In-Reply-To: <1415138202-1197-4-git-send-email-joestringer@nicira.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
	 <1415138202-1197-4-git-send-email-joestringer@nicira.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UPPHtNNYuZp+3X3P8osf"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UPPHtNNYuZp+3X3P8osf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-11-04 at 13:56 -0800, Joe Stringer wrote:
> ndo_gso_check() was recently introduced to allow NICs to report the
> offloading support that they have on a per-skb basis. Add an
> implementation for this driver which checks for something that looks
> like VXLAN.
>=20
> Implementation shamelessly stolen from Tom Herbert:
> http://thread.gmane.org/gmane.linux.network/332428/focus=3D333111
>=20
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
> Should this driver report support for GSO on packets with tunnel
> headers
> up to 64B like the i40e driver does?
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)

Thanks Joe, I will add your patch to my queue.

--=-UPPHtNNYuZp+3X3P8osf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUWhlYAAoJEOVv75VaS+3O1t0P+QHJT5Kbb0dpZzL8Dnw93MMl
LhYfeqwovuuie3yyy/XnNU9oll/gKfixcz/vIEh9RKNngt6aOESZFQCH14bc4tUB
tELwHoUZovlVGn1+JrBJh0zguo0/ohO0QT5XD8UAIt0QN6mMMzP545YbPkq1w6K9
dRpF2v8+UhCQetZJGvTXFQnEJkB7lgqZJPRa91voX7mPMia/9x9CsnE8rucMcraT
+YRCG5KejRqSbqKy3wcanf7h0xDqL6WzhJ8geDYYGR60qaI70gX9AV+kdrOIMfEt
KquC5zdSBPJkpIGPAgv6trhFuh/cHakdbGg5J+6IXpkbertXOiIUebXAW0WFGfEu
gp60X3GjvIvOrP/hdWIxhKrsucnfhulNA46K8VhuTNS1w258bnJtCXSmlnzDPMc5
ruCf13VJbe4y9+svyKjttkiLR3RygQwRQh3CcQjcWU8rpNBj25Q7BEltG5kJ5Er3
H0yPEIfjVKMWthF71JW9XvG1YGJGfZaxHhVvRctE18WebEuFi6fzljvhOzGzPlR7
WopkdjW3CpJ1lXspLDbmiqK/M1g3gxMgwzpI8l/CNRZEGyBoyg7cS3D0u+L8FD/b
4tnipND08bdu0jHnxSbgoV0qLr54m8JcTLqae7GiP8Szl8sX/SQbcxzMjxEEQMz9
jMa6OTj187Ylr+OyreeD
=uyNV
-----END PGP SIGNATURE-----

--=-UPPHtNNYuZp+3X3P8osf--

