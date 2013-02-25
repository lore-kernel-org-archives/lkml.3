Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3BYWP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:15:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3BYWPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:15:25 -0500
Date: Mon, 25 Feb 2013 14:14:09 -0800
From: tip-bot for Konrad Rzeszutek Wilk <tipbot@zytor.com>
Message-ID: <tip-a2fd6419174470f5ae6383f5037d0ee21ed9833f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, stable@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        tglx@linutronix.de, stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <1361825650-14031-3-git-send-email-konrad.wilk@oracle.com>
References: <1361825650-14031-3-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] doc, kernel-parameters: Document 'console=hvc<n>
 '
Git-Commit-ID: a2fd6419174470f5ae6383f5037d0ee21ed9833f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Feb 2013 14:14:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2fd6419174470f5ae6383f5037d0ee21ed9833f
Gitweb:     http://git.kernel.org/tip/a2fd6419174470f5ae6383f5037d0ee21ed9833f
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Mon, 25 Feb 2013 15:54:09 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Feb 2013 13:42:15 -0800

doc, kernel-parameters: Document 'console=hvc<n>'

Both the PowerPC hypervisor and Xen hypervisor can utilize the
hvc driver.

Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1361825650-14031-3-git-send-email-konrad.wilk@oracle.com
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c4cc199..986614d 100644
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
