Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3A3RbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:31:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab3A3RbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:31:12 -0500
Message-ID: <510958D5.7060206@suse.com>
Date: Wed, 30 Jan 2013 12:31:01 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ptp: PTP_1588_CLOCK_PCH depends on x86
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EG20T PCH is only compatible with Intel Atom processors so it
should depend on x86.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -72,6 +72,7 @@ config DP83640_PHY
 
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
+	depends on X86
 	select PTP_1588_CLOCK
 	help
 	  This driver adds support for using the PCH EG20T as a PTP

-- 
Jeff Mahoney
SUSE Labs
