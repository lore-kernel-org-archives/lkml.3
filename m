Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3BYUyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:54:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab3BYUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:54:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] kernel-parameters: Document 'console=hvc<n>'
Date: Mon, 25 Feb 2013 15:54:09 -0500
Message-Id: <1361825650-14031-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
References: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the PowerPC hypervisor and Xen hypervisor can utilize the
hvc driver.

CC: gregkh@linuxfoundation.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 73d51ed..7b41fba 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -564,6 +564,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
+		hvc<n>	Use the hypervisor console device <n>. This is for
+			both Xen and PowerPC hypervisors.
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
-- 
1.8.0.2

