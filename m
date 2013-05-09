Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3EIAf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:35:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53767 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3EIAf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:35:27 -0400
Date: Thu, 9 May 2013 10:35:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <michal.simek@petalogix.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the microblaze tree with Linus' tree
Message-Id: <20130509103513.8432fb1f7834a57de404f2a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_May_2013_10_35_13_+1000_+4wiyv4RlyGCRGSS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_May_2013_10_35_13_+1000_+4wiyv4RlyGCRGSS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the microblaze tree got a conflict in
arch/microblaze/mm/init.c between commit 7beb5987875b ("mm/microblaze:
use common help functions to free reserved pages") from Linus' tree and
commits 17408c87ba9e ("microblaze: Fix free_init_pages function") and
c5c09c08718b ("microblaze: Fix initrd support") from the microblaze tree.

I just used the version from Linus' tree (I am not sure if that is the
correct solution) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__9_May_2013_10_35_13_+1000_+4wiyv4RlyGCRGSS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiu9BAAoJEECxmPOUX5FEiyoQAKSaI66L6IlJ0JfV8EsjiOTq
VMQEBSvnK8Ny+7ynIY3C2KAUHoePtCigKGo1jDK1aLgkPxJDZzgAj742sB4mtvRP
8BKqodFSkByuupyQ+bgwZuqhUtRdNbO9lp461e27tg6A2aPngAS5C70wnAnCi4IO
Ic78Ry2bVbgYr3+I4gne19N0eE+2RT54RA/QJ8BMZsp1nxf3672WRK2WixpiKvCD
BxYUjGtLl6SP1HC11dVzV6qsZ6/rvZIxBzw1Ic0t8fjFbfMddLNWLYe2oOmo/a6U
4Ctp/4v2rV4V0yE44wp+qx0m4fNRYwNQkTqNdxR4r04IWAuv8T/lMq922cDUDbHl
I+X9WlNzthEwqW7vFUVqyYw7cmxJIta751dtu3JiiTs5pP6oeRX1LTi3ahIPghGu
25gF9a+MhwnIvYLLPvFfORFbXAobAOxejnjDUohVXQVHLkV2ULbBaFXgjktGQAhC
Czru1QRS+3hPo4Xf+EOuq9v+1WxNRwLXIt4iGn/1lhl1OF4ZDX4bajeptLkYzoBw
UnLrqnMtXc0GAx5CvsBDjEl0vJhxtf/lLcAcmpJa3efnllciLtWKwYRwEEXjNb6p
LbrK9bDLZXpsRFWJblwJ05HcFaSsVN5ujPh/3zPANgp+jMIBChXUcMvjHUUN88QX
cVogTxrP2jc8ugWQ0nPX
=3Qx6
-----END PGP SIGNATURE-----

--Signature=_Thu__9_May_2013_10_35_13_+1000_+4wiyv4RlyGCRGSS--
