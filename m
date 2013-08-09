Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab3HIB7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab3HIB7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 097/102] ndisc: Add missing inline to ndisc_addr_option_pad
Date: Thu,  8 Aug 2013 18:58:13 -0700
Message-Id: <20130809015033.154980354@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

[ Upstream commit d9d10a30964504af834d8d250a0c76d4ae91eb1e ]

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ndisc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -119,7 +119,7 @@ extern struct ndisc_options *ndisc_parse
  * if RFC 3831 IPv6-over-Fibre Channel is ever implemented it may
  * also need a pad of 2.
  */
-static int ndisc_addr_option_pad(unsigned short type)
+static inline int ndisc_addr_option_pad(unsigned short type)
 {
 	switch (type) {
 	case ARPHRD_INFINIBAND: return 2;


