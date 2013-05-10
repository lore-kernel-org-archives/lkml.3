Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3EJQOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:14:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3EJQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:14:05 -0400
Date: Fri, 10 May 2013 09:14:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] driver core: export subsys_virtual_register
Message-ID: <20130510161404.GA17918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Modules want to call this function, so it needs to be exported.

Reported-by: Daniel Mack <zonque@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/bus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -1295,6 +1295,7 @@ int subsys_virtual_register(struct bus_t
 
 	return subsys_register(subsys, groups, virtual_dir);
 }
+EXPORT_SYMBOL_GPL(subsys_virtual_register);
 
 int __init buses_init(void)
 {
