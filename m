Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab3DZDZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 23:25:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42483 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab3DZDY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 23:24:59 -0400
Date: Fri, 26 Apr 2013 13:24:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ariel Elior <ariele@broadcom.com>, Yuval Mintz <yuvalmin@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-Id: <20130426132447.c7b06622240088ccad366b03@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_13_24_47_+1000_lJ3vT5H58WdOBOzT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_13_24_47_+1000_lJ3vT5H58WdOBOzT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c between commit
ecf01c22be03 ("bnx2x: Prevent NULL pointer dereference in kdump") from
the net tree and commit 5b0752c863d7 ("bnx2x: Fix VF statistics") from
the net-next tree.

I am not sure about this, but I just used the net tree version but I
assume something more may be needed and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Apr_2013_13_24_47_+1000_lJ3vT5H58WdOBOzT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRefN/AAoJEECxmPOUX5FE36sP/0kJoDfmmXguCRUUiBEc6fQm
DefgUvrrX3iD/yBK4Qdj27T53v0VD6IKv5/RP9/pIpsYeIg3qbkyZGtNnpkey3z7
DXpn237K8A0wEWiQcVRqN66GBKNUrjrK3wEnGT+Sa0aq6GsmZ28USlRBgDDpjY98
YGxG45HVuqZloatkEmwR7QnPg4CA3+kpQwyu/3jL73tx8ocLlZZWOUNs+X6RCCom
MzUHfKMXuA9/YfO8RTthhrTSdWSLxL2XJXrQ7uUhHwDOUQXWT93K9BZ2JwqTlhAa
of8PACoLsY70naOsHvf1LDCMGSy8ibh6s5HFyiCfygF7oWCtZdxR8xOwCPGUBX0Z
vthJDMtKSYCQxgvfON6LaNuoHHJ7al0WeGGfbUVquW3DjvRusxAwYU8oPhQ4F7ag
Q+0MtXgxvrTR0IFgIQfPPsRxGhWguhXsC5Knzn5L6WaxROoU/dJNqBirPR8ZNZyo
mrd2npOcyw7RHcnhEyBb3fuzx9ZcsI43uJIJQjqTJ707VTBfqVbTqzexlt8Jfawd
D3LmIjxbivfTEN4Xi7/T53OcCQHu0Gjr3yeFEZR2PASZqZk3kIEnVixu6riG/FDq
DGHdfaXcs0JWWFucyE6fcld4he8ZjRwV41X+sXPU19FEPDoRWecU0MUhxr5mgMQ7
Y9heAwAXEpI6mUIBluka
=yuBy
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_13_24_47_+1000_lJ3vT5H58WdOBOzT--
