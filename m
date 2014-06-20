Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967166AbaFTUZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:25:37 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35117 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaFTUZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:25:36 -0400
Message-ID: <53A498B2.1000808@gmail.com>
Date: Fri, 20 Jun 2014 16:25:22 -0400
From: Ramesh Basukala <basukalaramesh@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/01] Drivers: Fixes coding style warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*

From: Ramesh Basukala <basukalaramesh@gmail.com>


Attached is a patch which fixes coding style warning message while 
running checkpatch script.


This patch is currently against a linux 3.15.0-rc15-next kernel. I am 
submitting this patch as a part of Eudyptula Challenge task.


Signed-off-by: Ramesh Basukala <basukalaramesh@gmail.com>
*---
Signed-off-by: Ramesh Basukala <basukalaramesh@gmail.com>
--- xlr_net.c.original 2014-06-20 15:32:10.069732488 -0400
+++ xlr_net.c 2014-06-20 15:35:06.841105038 -0400
@@ -1105,6 +1105,7 @@ err_gmac:
static int xlr_net_remove(struct platform_device *pdev)
{
struct xlr_net_priv *priv = platform_get_drvdata(pdev);
+
unregister_netdev(priv->ndev);
mdiobus_unregister(priv->mii_bus);
mdiobus_free(priv->mii_bus);
**
