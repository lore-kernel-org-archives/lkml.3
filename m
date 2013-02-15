Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393Ab3BOGvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:51:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45240 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3BOGvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:51:01 -0500
Date: Fri, 15 Feb 2013 17:50:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm tree with the workqueues tree
Message-Id: <20130215175049.fb45cedf6248d881c8156427@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_17_50_49_+1100_uJm.2MahWbmcNT3m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_17_50_49_+1100_uJm.2MahWbmcNT3m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/workqueue.c between commit 8d03ecfe4718 ("workqueue: reimplement
is_chained_work() using current_wq_worker()") from the workqueues tree
and commit "hlist: drop the node parameter from iterators" from the akpm
tree.

I fixed it up (the former removes the code changed by the latter, so I
did that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_17_50_49_+1100_uJm.2MahWbmcNT3m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHdrJAAoJEECxmPOUX5FEFa0P+wcJ3LrOAGeE68T0S2rmLrVG
Szaw0fFEMxJXesbjl5cQkYv1l1tPaiv+X4wY+7srvcpqCs150FVjpyj96rPc40Ip
R8VkA1OsCjvpNxMPuXXyvQCMvf4hKbMJWULRidr0pcIsQTP5Czr7dcvyOv2RJvKr
xTaFpVK5mSks9SMj9g00Y394c1yqdF4m7PRj6teCYJN+npyNoQK9rzGLtP2Autep
ybxhMGrK0ulET3e0xEOEkMmd1PTKEuf0scW4gOa8JX8YbcUS0XXpTizPkqPtYlvO
Brm7N+ZDsITN8ah0H/mRZyuVCESX87pkIcyWLbBH/x9rn9KIdVqQ8MPU1OUc91NL
ffzwKCQf/BIrxi7qRMEffMHIjDDYAPulSxSZmThZ3zevIFiPnbuyxffrbkqwPd2H
jw0Ks+S9b0s1X3WL0MN1WzxkawTzyYOrlkWIXQibnfPTpGDkdZ4s6eN1FhdYFjIS
1Y8eyRmVrmLspyJqplT6r37R4mrLNwZ8SfVZqKrVi/2uPq9lpUbDNVhX4Grl1qcC
zpIC/CLpbUjfxkFlvFkkhv1/pwCmC5Qi7WWOCBrL0tYme7MSfOC9aBOp7Amsno0P
D6CZZJreATiyw82VGLdXnF78jDhTkLVD7l0pWC8Xtqd0sJR2K1OYvgcrR7UtwCk4
mz1mOj0hDPHnXTqB5Jsd
=ZtI9
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_17_50_49_+1100_uJm.2MahWbmcNT3m--
