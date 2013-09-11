Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3IKFmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:42:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3IKE5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:14 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nu8lv7MQO0QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=irKeplGv5VcA:10 a=IJv9LcIfAAAA:8 a=J1Y8HTJGAAAA:8 a=qxhprz7Bzh8pFVeTsJcA:9 a=K6kUPx8HyhEA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042919.697469892@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [164/251] ndisc: Add missing inline to ndisc_addr_option_pad
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0164-ndisc-Add-missing-inline-to-ndisc_addr_option_pad.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

[ Upstream commit d9d10a30964504af834d8d250a0c76d4ae91eb1e ]

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/ndisc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 826a541..9761757 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -118,7 +118,7 @@ extern struct ndisc_options *ndisc_parse_options(u8 *opt, int opt_len,
  * if RFC 3831 IPv6-over-Fibre Channel is ever implemented it may
  * also need a pad of 2.
  */
-static int ndisc_addr_option_pad(unsigned short type)
+static inline int ndisc_addr_option_pad(unsigned short type)
 {
 	switch (type) {
 	case ARPHRD_INFINIBAND: return 2;
-- 
1.7.10.4


