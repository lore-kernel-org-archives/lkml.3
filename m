Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3CATxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:53:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3CATqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 06/30] doc, kernel-parameters: Document console=hvc<n>
Date: Fri,  1 Mar 2013 11:45:27 -0800
Message-Id: <20130301194528.681091168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit a2fd6419174470f5ae6383f5037d0ee21ed9833f upstream.

Both the PowerPC hypervisor and Xen hypervisor can utilize the
hvc driver.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1361825650-14031-3-git-send-email-konrad.wilk@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kernel-parameters.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -531,6 +531,8 @@ bytes respectively. Such letter suffixes
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
+		hvc<n>	Use the hypervisor console device <n>. This is for
+			both Xen and PowerPC hypervisors.
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance


