Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaFHIxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 04:53:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:21994 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbaFHIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 04:53:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,997,1392192000"; 
   d="asc'?scan'208";a="544567517"
Message-ID: <1402217625.3039.1.camel@jtkirshe-mobl>
Subject: Re: [linux-nics] [PATCHv3 2/3] list: Fix order of arguments for
 hlist_add_after(_rcu)
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ken Helias <kenhelias@web.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Linux@isotope.jf.intel.com, linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 08 Jun 2014 01:53:45 -0700
In-Reply-To: <1402159211-12629-2-git-send-email-kenhelias@web.de>
References: <1402159211-12629-1-git-send-email-kenhelias@web.de>
	 <1402159211-12629-2-git-send-email-kenhelias@web.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o0coTsBl9GGr9ZZ4GW3Z"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o0coTsBl9GGr9ZZ4GW3Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-06-07 at 18:40 +0200, Ken Helias wrote:
> From: Ken Helias <kenhelias@firemail.de>
>=20
> All other add functions for lists have the new item as first argument
> and the
> position where it is added as second argument. This was changed for no
> good
> reason in this function and makes using it unnecessary confusing.
>=20
> The name was changed to let old code generate a compile errors instead
> of
> using the wrong parameter order.
>=20
> Signed-off-by: Ken Helias <kenhelias@firemail.de>
> Cc: Linux NICS <linux.nics@intel.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: e1000-devel@lists.sourceforge.net
> Cc: netdev@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: bridge@lists.linux-foundation.org

For the Intel driver changes...
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
> Patch based on "Add linux-next specific files for 20140606"
>=20
> v3:
> renamed from hlist_add_after* to hlist_add_behind
>=20
> v2:
> Splitted into two patches
> reduced number of Cc
>=20
>  Documentation/RCU/whatisRCU.txt                  | 2 +-
>  drivers/gpu/drm/drm_hashtab.c                    | 2 +-
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c   | 2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 +-
>  drivers/staging/lustre/lustre/libcfs/hash.c      | 4 ++--
>  fs/namespace.c                                   | 2 +-
>  fs/notify/inode_mark.c                           | 2 +-
>  fs/notify/vfsmount_mark.c                        | 2 +-
>  include/linux/list.h                             | 4 ++--
>  include/linux/rculist.h                          | 8 ++++----
>  net/batman-adv/fragmentation.c                   | 2 +-
>  net/bridge/br_multicast.c                        | 2 +-
>  net/ipv4/fib_trie.c                              | 2 +-
>  net/ipv6/addrlabel.c                             | 2 +-
>  net/xfrm/xfrm_policy.c                           | 4 ++--
>  15 files changed, 21 insertions(+), 21 deletions(-)



--=-o0coTsBl9GGr9ZZ4GW3Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJTlCSZAAoJEOVv75VaS+3Ok5UQAKJkXA4phG5ywUso5FFKUi7c
GmuypU0v+yAQqOtyIApE0pzTbn4Sdm1Dr9ihhYSCM5om/iAEyzVFsyGBtW7SHMOE
s9HxS+g6XBITslWreVlKpc/78cjvUNldUF1zbbySP7D+BrOWZNufXhJAlmQMt+rp
cA5jAIELq1FrRDSWCaiWQio99Mp9I8b5WPLM1ruBgIBiHUkDUO7bkSi8pN4ph87Z
/2QRmwTt4P1TLRSQe++4LXIl/fBFebr+dGWNSVHrehJPBorRejORRfGH++wsjzqS
vR+lmTreMbWOY6LegOifBji0PBRuMcgqaCknb0bFsmsa/HKUokLgL7DoUhfRKPIQ
EQznC+AJZop5QGbcIEiqr16UhySit/4kKBYOqMccz20wegL6Kpza4TUKzJdhZZ6a
7toLQQSjcQGp26kJE0qQqh0qGIfc0cV3vX7shN66cjA/GwFhFUzHLvnnRRf5JbTd
hJf7JJ4DDXBtr/qtOQTVwxwfaWqgOu41pO7/SZpBysL6KC5smifJFdKtPCW1/xet
kbO9p7vMAJND78bCC45wjebJd6ir0Ul/W5QhNOSyWSLfSG69vBB3aiJYf+24wUn4
3q6TvLgRPYeOqqwT1rRRNl00UWbPeoWEcbGIddU83D7xXhwbFRjqzDPXZjIMezyL
7YK2Y4ACs689I34gyeKD
=NPkK
-----END PGP SIGNATURE-----

--=-o0coTsBl9GGr9ZZ4GW3Z--

