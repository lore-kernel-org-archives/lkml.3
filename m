Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600Ab3DGW5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:57:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49654 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525Ab3DGW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:56:58 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-be-5161f9b848de
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Jay Vosburgh'" <fubar@us.ibm.com>,
        "'Veaceslav Falico'" <vfalico@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable]  bonding: remove sysfs before removing devices
Date: Mon, 08 Apr 2013 07:56:52 +0900
Message-id: <004601ce33e3$3437d4b0$9ca77e10$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtXBJYA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA90dPxMDDU6tN7fon3GA1WJJM7fF
	5V1z2CwWbHzEaLFn+URGB1aP9/uusnn0bVnF6HHuWh+zx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	vft/sxRM566YuKuVqYFxC2cXIweHhICJxJvpbl2MnECmmMSFe+vZQGwhgWWMEgvO8EDETSRm
	zPnNChFfxCix9apYFyMXkP2XUWLqv/NgCTYBXYlj67eA2SIC3hKnpvxiBrGZBTIkpq45wAiy
	S0iAW2J1cxBImFOAR2Ldn06wEmEBL4n9i5eygNgsAqoSi77/ZQUp5xWwk/j4WAUkzCsgKPFj
	8j0WiIlaEut3HmeCsOUlNq95ywzxibrEo7+6EAc4Sex7/Z4VokREYt+Ld4wgF0sIXGOXaF/4
	iw1ilYDEt8mHWCB6ZSU2HWCG+FZS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILi
	pPQiU73ixNzi0rx0veT83E2MkKicuIPx/gHrQ4zJQOsnMkuJJucDozqvJN7Q2MzIwtTE1NjI
	3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxM6ybpqv7+0zPf+vz2i/qL
	jk/ZvGdCfNbUFacNcxu/f8nWT3SSKfT6d/LpWVHGIq2v6y1iHk/2Krq3W1lA2qDYoGHPn2zb
	Da0dbVPMZj/NczidFxTx/KHSgve8hxu+z5ue8E/v/5mKbCbrpQk7tlkGBdzPm+YrNV1K4YHq
	nA8//u0I4g1pnXVHiaU4I9FQi7moOBEAEjbQieACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd0dPxMDDb59MLTon3GA1WJJM7fF
	5V1z2CwWbHzEaLFn+URGB1aP9/uusnn0bVnF6HHuWh+zx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGb37f7MUTOeumLirlamBcQtnFyMnh4SAicSMOb9ZIWwx
	iQv31rOB2EICixgltl4V62LkArL/MkpM/XcerIhNQFfi2PotYLaIgLfEqSm/mEFsZoEMialr
	DjB2MXIANXBLrG4OAglzCvBIrPvTCVYiLOAlsX/xUhYQm0VAVWLR97+sIOW8AnYSHx+rgIR5
	BQQlfky+xwIxUUti/c7jTBC2vMTmNW+ZQcolBNQlHv3VhTjASWLf6/esECUiEvtevGOcwCg0
	C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguP+mdQOxpUNFocY
	BTgYlXh4JX8kBgqxJpYVV+YeYpTgYFYS4e19CBTiTUmsrEotyo8vKs1JLT7EmAz050RmKdHk
	fGBKyiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxt7tz19W
	8jQfsyxKzokWubQ2MXDpirhT925yrJe+fuJMudv7zA1TM/anLuBqyneYVyDDeNE39MNh85es
	4hkvK+f/Wh7v+bgqkG/bkuVn/LKXRofMms9l+kU8iVM2R3/dqbNNVza8ib+t8/rWZfuljo/j
	J5t+OZS0cn3R9y1NP/okHuQq7Z5hIajEUpyRaKjFXFScCACSoxxAPwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Veaceslav Falico <vfalico@redhat.com>"

commit 4de79c737b200492195ebc54a887075327e1ec1d upstream

We have a race condition if we try to rmmod bonding and simultaneously add
a bond master through sysfs. In bonding_exit() we first remove the devices
(through rtnl_link_unregister() ) and only after that we remove the sysfs.
If we manage to add a device through sysfs after that the devices were
removed - we'll end up with that device/sysfs structure and with the module
unloaded.

Fix this by first removing the sysfs and only after that calling
rtnl_link_unregister().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c
b/drivers/net/bonding/bond_main.c
index 27cdf1f..fb6b559 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4975,8 +4975,8 @@ static void __exit bonding_exit(void)
 
 	bond_destroy_debugfs();
 
-	rtnl_link_unregister(&bond_link_ops);
 	unregister_pernet_subsys(&bond_net_ops);
+	rtnl_link_unregister(&bond_link_ops);
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	/*
-- 
1.7.9.5

