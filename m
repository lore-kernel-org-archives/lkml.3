Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3LUNzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 08:55:52 -0500
Received: from ozlabs.org ([203.10.76.45]:34148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3LUNzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 08:55:50 -0500
Date: Sun, 22 Dec 2013 00:43:55 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 02/14] mm, hugetlb: region manipulation functions take
 resv_map rather list_head
Message-ID: <20131221134355.GA12407@voom.fritz.box>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-3-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1387349640-8071-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 03:53:48PM +0900, Joonsoo Kim wrote:
> To change a protection method for region tracking to find grained one,
> we pass the resv_map, instead of list_head, to region manipulation
> functions. This doesn't introduce any functional change, and it is just
> for preparing a next step.
>=20
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJStZsbAAoJEGw4ysog2bOS9PcQAI9nfhpAOn9DmhrqDkuAstNt
g7WyzXBgqrwePCSB/0llVIT8ZxI0cdfL3GX3ogkkwLVMcRiEX6MTR4yYoVjVX6EN
ZNdAN78D+A77soDBFpDI4+1SKYAwG8S2E94L+eceq75nzGrZ9iykw+CqcLuSagOl
WthYxjzoxPOdGF1rmMEsLZM32BFp/cHcEnNZAGBrylivb5yOm9RWvBhkBUUZO4dQ
xQva/kHP4MzP9ktC7njHNO/TwiGmK9Wln4Kqcf+IyT6PH5G6IVCcaXMQFHvr6ZqW
QJ6bqOBwT4V6FKE8TbDZ0NxwR0sNB26kR+nRkePyzsYNfKbuTV63P9noN3MzmypD
ZMLo7773qUmUWw7sTux6fddr3zsZyzxUlnxKEI/PajBJ6pczAHQnBJcKDnTU2Ivd
MEkBa8swsdggldrZP1VEfEGCIbJr8zvRjJCGtpGyvu1Ot/eDasyIPFSsVD9Np8PL
PsYHS3SIBjH4ZlBZziEqcZPkG8xuu3hwCvuUlHltV3QGuzWANVwqC3wM3DpwixZp
MVKeIz5HJJinYyKUx9SS0i4k8tHUEHgYkUSQqrf/bSlQYGn+O+ZnepbcJ3wazVee
FhGKtm9rjus2/YEB3hRDuIKqpacpcmaKDH1lg1P8dTqZns76jCvs4d0ttAig3itp
URAzCzZEBcXf9Vf0md/S
=LC9f
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
