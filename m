Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3DJLKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:10:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33775 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3DJLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:10:06 -0400
Date: Wed, 10 Apr 2013 21:09:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tang Yuantian-B29983 <B29983@freescale.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: remove the unnecessary of_node_put for
 of_parse_phandle_with_args()
Message-Id: <20130410210950.972df35671f7fa5573ef2d7b@canb.auug.org.au>
In-Reply-To: <D07C73A334FF604B95B3CBD2A545D07B0B128AE0@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365490569-32455-1-git-send-email-Yuantian.Tang@freescale.com>
	<20130410190327.a70d4c3798509d664aef2f13@canb.auug.org.au>
	<D07C73A334FF604B95B3CBD2A545D07B0B128AE0@039-SN2MPN1-013.039d.mgd.msft.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_21_09_50_+1000_qXeBHYRWuh+e7ml+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_21_09_50_+1000_qXeBHYRWuh+e7ml+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 10 Apr 2013 09:06:11 +0000 Tang Yuantian-B29983 <B29983@freescale.c=
om> wrote:
>
> Yes, I already sent out the v2 patch.
> Please see: http://patchwork.ozlabs.org/patch/235288/

Thanks.  I should read all my email before replying to it :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_21_09_50_+1000_qXeBHYRWuh+e7ml+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZUh+AAoJEECxmPOUX5FEeAEP/0CDnfupqEJGQK/TSg8+gfG8
jota7lb/iIaPnxryLAZRlkUC+qGvrd5ZPokbbZhYeDPcTuDGSqBuTBwtP03Fa05D
Ihw5OkO17uJzcEcP0LBYvdHRcMxVNT1ag5nuT9Dk9phjTS++JQC85aBzatZJN+/i
wEn37tbdHIOayb9HYHjA7/0e8dDx+QJdA9tag4lZ/dm0zD44KEF3ynUFbH2FeAQs
03Ptkv6PKcWfmCniMGaODDauy4tmtFuLteOPx7rqLLX1zd/DRTsr6JdRup5S/8q+
6g2TTr37xFd5hfCLE2QZPiIyxualsCgsWkVcfRFr22LGY5auNZ0oNd2IxP5CfArv
pqxJtBzBxfDZ7mtAMZlhxeEzy3JetNPGWga9MJ7w/En97O9406f49dDZn+022m4N
aSyJyTzR7q0NbvzzfMt+wEa6ntWiK1zs3Gixf1Do4a1cJ23rjqga3rpGMZwrSFwr
DLmUdwJaVoORil0Hn1S5OfmGa+UwgL55raJYOmIcm3AmiOpw4zRtpUh/NCQuxsLY
tzoZ3tQ5Ind0mc2mbgeUN+jFp9O0agjK6qM7pZi7K+t7kgaCvnPAWNR1Emvw5o98
7gU67bByN+FjrOc2lRYFRzr7EQ/7GtmPMC59g+tAP8lK51wV8xNtywLb/3Zf9fZs
fd53wL/NgPRUadbj9BxY
=au+7
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_21_09_50_+1000_qXeBHYRWuh+e7ml+--
