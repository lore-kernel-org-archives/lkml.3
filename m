Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3ETAWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 20:22:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44969 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3ETAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 20:22:08 -0400
Date: Mon, 20 May 2013 10:21:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Libo Chen <clbchenlibo.chen@huawei.com>
Subject: linux-next: manual merge of the usb.current tree with Linus' tree
Message-Id: <20130520102159.18f2f976cb4000e48b45731e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_May_2013_10_21_59_+1000_HZwVN/Oi/lUBq=0M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_May_2013_10_21_59_+1000_HZwVN/Oi/lUBq=0M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb.current tree got a conflict in
drivers/usb/host/ohci-nxp.c between commit bb522812a1a6
("drivers/usb/host: don't check resource with devm_ioremap_resource")
from Linus' tree and commit b3517d5de80e ("usb: ohci: fix goto wrong tag
in err case") from the usb.current tree.

The former remove a bit of code modified by the latter, so I did that and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_May_2013_10_21_59_+1000_HZwVN/Oi/lUBq=0M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRmWynAAoJEECxmPOUX5FEohkP/i/pIKJ5KEp1ekF0DHGCxnI+
3xJW3PQjZCDFfgW/KVy8xB8PFEnN6IUzYGiCH9CgKWaVsacQlsPuvCCDFrYhlL/P
iMoM3k1IKIEPUexahYOS20t1HgBu7X8nDwmZ2nr7K3E1qi5RzSfros72/ghPDtDP
kKXX5ZU2lTY1Bhr0PyLKjS1hu0dXyKJkutcwrPOa71AOlqbQV407fQE2Y22IVQPQ
/c4U2qxzYkgIlfppRbDu1BBJKugeV0eOcXknOv49CaBtnDYRNf264EACJmoyzciV
jIMLMHaKIm3+PnUihuzFH9tbcPzJ+6ZOAw0XnNWiNtjAuFiUK+b7zgz6ZgQN9BsO
uIoB3H86PeYVkFcIKjB58e7VV1swWQjUDp7BzJWz8NVlDZg14s1oydBOB0JRGNgE
09MEDMhzqADOXXMhxrezt97L8D984rRoAIAJVyWy68Ji+Wuq0BaYNA7etA3Cvdwi
w2dmoEE87RocwjsZbgBpdbBghItVPCDWcYtGm8DpS90VAg/UMlFZpoGkYtfX8oIK
uJy2WRTWzedHYcn2Rn/PR3ryvSXgmkur31kPMaJ1XjFvejDpBe9PZQc+Udy9cfDz
SYghFOqqWumVvTdtmzNCFbPwrj4r1y9sFkNZDWZUNOmhkRqQWXQYvdmGtY00765H
rbNqA1ODlmc6Od9AMa88
=R27y
-----END PGP SIGNATURE-----

--Signature=_Mon__20_May_2013_10_21_59_+1000_HZwVN/Oi/lUBq=0M--
