Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab3DKAbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:31:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55420 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934913Ab3DKAbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:31:46 -0400
X-AuditID: cbfee690-b7f656d0000007e3-7e-51660470a1a0
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Vlad Yasevich'" <vyasevic@redhat.com>,
        "'David S. Miller'" <davem@davemloft.net>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] net: count hw_addr syncs so that unsync works
 properly.
Date: Thu, 11 Apr 2013 09:31:44 +0900
Message-id: <000001ce364b$f1b178b0$d5146a10$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtXBJYACaKDZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zA90ClrRAg9O3DSzmnG9hsVjSzG1x
	edccNosFGx8xWhx59pXVgdVjy8qbTB7v911l8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	DZevsRUsEK74/u8ucwPjIf4uRk4OCQETicsPutkgbDGJC/fWA9lcHEICyxgl+mZtYO5i5AAr
	Ovk9HCK+iFHi4o8NrBDOX0aJRzefM4J0swnoShxbv4UVxBYR8JY4NeUXM4jNLJAn8eDcAzaQ
	QUIC3BKrm4NAwpwCPBLr/nSCzRcWCJX4c5wLJMwioCoxfeYMJhCbV8BOYtPnpSwQtqDEj8n3
	WCAmakms33mcCcKWl9i85i3UmeoSj/7qQhzgJnHp131WiBIRiX0v3jGCXCwhcI1d4sW5iywQ
	uwQkvk0+xALRKyux6QAzJBgkJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkov
	MtErTswtLs1L10vOz93ECInMCTsY7x2wPsSYDLR+IrOUaHI+MLLzSuINjc2MLExNTI2NzC3N
	SBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDot1K/80bkkeqJ4S/FmH69sv2+
	8PXUTZnnGh+0X3Fifavi4X0yleEm27LFE3YoNfGk69SzO5Sffjc/+e+uvzuONE8/sPL63++7
	tr/mWWxl/0v/eHpGbue0Tm6By3/nGc3lXuD8pDmdYX7PZcVs3+yCr+m7N28+GGFbOkFQ8vJm
	iah+5aigiyvOK7EUZyQaajEXFScCAKSwd4LiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd0ClrRAgzuHtS3mnG9hsVjSzG1x
	edccNosFGx8xWhx59pXVgdVjy8qbTB7v911l8+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjA2Xr7EVLBCu+P7vLnMD4yH+LkYODgkBE4mT38O7GDmB
	TDGJC/fWs3UxcnEICSxilLj4YwMrhPOXUeLRzeeMIFVsAroSx9ZvYQWxRQS8JU5N+cUMYjML
	5Ek8OPeADWSokAC3xOrmIJAwpwCPxLo/ncwgYWGBUIk/x7lAwiwCqhLTZ85gArF5BewkNn1e
	ygJhC0r8mHyPBWKilsT6nceZIGx5ic1r3jJDnKwu8eivLsQBbhKXft1nhSgRkdj34h3jBEah
	WUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERz3z6R2MK5ssDjE
	KMDBqMTDe6IhNVCINbGsuDL3EKMEB7OSCC/XTqAQb0piZVVqUX58UWlOavEhxmSgRycyS4km
	5wNTUl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MPboLhKd
	fbwtxkKQ0+BGypf0K59st7oK7f8w9/FbnsSMfxs6Uh52hhSVH0/8dIEp8ELFU7FVP/1nLbt/
	xt1I2jLzQrun0Qkjru8aytdcH62JWaEQ9lMk5MLCgMXbHiqICP4/fqRE5WJ7hfKO09siq3JS
	t3/WPDw1WXTb2UKHuTxHOd6eEZw3s12JpTgj0VCLuag4EQAuwOQZPwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Vlad Yasevich <vyasevic@redhat.com>"

commit 4543fbefe6e06a9e40d9f2b28d688393a299f079 upstream

A few drivers use dev_uc_sync/unsync to synchronize the
address lists from master down to slave/lower devices.  In
some cases (bond/team) a single address list is synched down
to multiple devices.  At the time of unsync, we have a leak
in these lower devices, because "synced" is treated as a
boolean and the address will not be unsynced for anything after
the first device/call.

Treat "synced" as a count (same as refcount) and allow all
unsync calls to work.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 include/linux/netdevice.h |    2 +-
 net/core/dev_addr_lists.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9ef07d0..0e182f9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -208,9 +208,9 @@ struct netdev_hw_addr {
 #define NETDEV_HW_ADDR_T_SLAVE		3
 #define NETDEV_HW_ADDR_T_UNICAST	4
 #define NETDEV_HW_ADDR_T_MULTICAST	5
-	bool			synced;
 	bool			global_use;
 	int			refcount;
+	int			synced;
 	struct rcu_head		rcu_head;
 };
 
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index b079c7b..7841d87 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -38,7 +38,7 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list
*list,
 	ha->type = addr_type;
 	ha->refcount = 1;
 	ha->global_use = global;
-	ha->synced = false;
+	ha->synced = 0;
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 
@@ -166,7 +166,7 @@ int __hw_addr_sync(struct netdev_hw_addr_list *to_list,
 					    addr_len, ha->type);
 			if (err)
 				break;
-			ha->synced = true;
+			ha->synced++;
 			ha->refcount++;
 		} else if (ha->refcount == 1) {
 			__hw_addr_del(to_list, ha->addr, addr_len,
ha->type);
@@ -187,7 +187,7 @@ void __hw_addr_unsync(struct netdev_hw_addr_list
*to_list,
 		if (ha->synced) {
 			__hw_addr_del(to_list, ha->addr,
 				      addr_len, ha->type);
-			ha->synced = false;
+			ha->synced--;
 			__hw_addr_del(from_list, ha->addr,
 				      addr_len, ha->type);
 		}
-- 
1.7.9.5

