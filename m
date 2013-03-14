Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3CNLDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:03:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3CNKhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 16/88] doc, kernel-parameters: Document 'console=hvc<n>'
Date: Thu, 14 Mar 2013 10:35:09 +0000
Message-Id: <1363257381-15900-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit a2fd6419174470f5ae6383f5037d0ee21ed9833f upstream.

Both the PowerPC hypervisor and Xen hypervisor can utilize the
hvc driver.

Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1361825650-14031-3-git-send-email-konrad.wilk@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 65f25d7..912785c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -570,6 +570,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
+		hvc<n>	Use the hypervisor console device <n>. This is for
+			both Xen and PowerPC hypervisors.
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
-- 
1.8.1.2

