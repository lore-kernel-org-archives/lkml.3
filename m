Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3CLAdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:33:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52276 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3CLAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:33:35 -0400
Date: Tue, 12 Mar 2013 11:33:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-Id: <20130312113320.b1f41dcb59baa74a51b064cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_11_33_20_+1100_9XMUROop0z_8UXdM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_11_33_20_+1100_9XMUROop0z_8UXdM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/ethernet/intel/e1000e/netdev.c between commits 4e0855dff094
("e1000e: fix pci-device enable-counter balance") and 66148babe728
("e1000e: fix runtime power management transitions") from Linus' tree and
commit f0ff439872e1 ("e1000e: cleanup CODE_INDENT checkpatch errors")
from the net-next tree.

The former removed the line fixed by the latter, so I did that and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_11_33_20_+1100_9XMUROop0z_8UXdM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPnfQAAoJEECxmPOUX5FEQIUP/At6swZienJ8i92Y53y8t1t8
tk/KsdXyZnopaH4NvUdyan4Q0BV39A9h3Mf8QBgA7m+spqSrwtrNivA9N3/CACnL
3XC71EywF1n4NtUPgEqxJNYBrYr9NN1DXwagDzsivP6HE4p2C001rB47lkqIV1QQ
y6NMBtZtwWDqlac8+m8phwKUDTW3D+c2OH2WCWaKUwc0NaDhm9NUD3F+7rr0j0pB
TWu8FJ1sbVibxQ3KMaF+qBKQ6ZVS9NJKUAz/6e3VlUnJMQ7d/mBdq8lFTvHqFWuG
wQ7BPGmeZkjMpSg3M4KbcxajFHvl5lLpxndhaYMKh76/Caz0Jy6NCLuyQoXql300
M4wfHxj3cw8MJZxu74xK3wj8sgc40xYiGYO3+n9f2eXltAi0tsH7lJzWlAHO9ZrE
C4DmzviahEgzwgq6/Wk/onnhMk0zHWa7EHwRnxKkS9BZjRy5vgCkcT3YuuZrxPoc
Jar3CBmnKzLu+uQXhW4UNf9HQHHbY81BL2bnFanbnOrD5RQWEJPEwoDmUKSKOent
NdNN4TZg5y0vCHqC7pnxQGVTwONOJqaa6CTMzbBAQQgas3WiUAjD2XlfRxty0dsS
pW9ncF/Qy0eHN/DmWetjKMOOnPjprl7eDizUIVHj0LhI3iS3zuj3urFlj/rlClXW
Z1xvSyASMA00L/U6Xvfx
=Thrz
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_11_33_20_+1100_9XMUROop0z_8UXdM--
