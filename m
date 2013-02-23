Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3BWHZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:25:46 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46543 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab3BWHZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:25:43 -0500
Date: Fri, 22 Feb 2013 23:25:38 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH] vxlan: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130223072538.GA4770@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 56c2d75..87f1d39 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -150,7 +150,7 @@ config MACVTAP
 
 config VXLAN
        tristate "Virtual eXtensible Local Area Network (VXLAN)"
-       depends on EXPERIMENTAL && INET
+       depends on INET
        ---help---
 	  This allows one to create vxlan virtual interfaces that provide
 	  Layer 2 Networks over Layer 3 Networks. VXLAN is often used
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
