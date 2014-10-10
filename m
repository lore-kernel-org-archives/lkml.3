Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaJJV77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:59:59 -0400
Received: from endruntechnologies.com ([64.142.115.26]:37695 "EHLO
	mail.endruntechnologies.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbaJJV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:59:58 -0400
X-Greylist: delayed 2500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2014 17:59:58 EDT
Message-ID: <54384D76.6050708@endruntechnologies.com>
Date: Fri, 10 Oct 2014 14:19:50 -0700
From: Mike Skoog <mskoog@endruntechnologies.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mkorreng <mkorreng@endruntechnologies.com>
Subject: Kernel Patch to add Endrun PCIe PTP card v1 (2/2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=====================================================
Subject: [PATCHv1 2/2] 8250_pci: pci.ids: EndRun Technologies PTP PCIe
card recognition.
From: Michael Skoog <mskoog@endruntechnologies.com>

Add recognition of EndRun Technologies PCIe PTP slave card
and setups two ttySx ports to communicate to the card for
retrieval of PTP based time and to communicate with the card's
Linux OS.

Signed-off-by: Michael Skoog <mskoog@endruntechnologies.com>
Signed-off-by: Mike Korreng <mkorreng@endruntechnologies.com>

---

The kernel patch is currently against linux 3.17 kernel, for the x86
architecture.

The pci.ids patch is against the Slackware 13 distribution.

diffstat:
 pci.ids |    2 ++
 1 file changed, 2 insertions(+)

Please let me know any feedback you have on this patch or the approach used.

Thanks,

=====================
Michael Skoog
Software Engineer
EndRun Technologies
=====================

--------------------------------------------------------------------------------
diff -up /usr/share/pci.ids{.orig,} > /tmp/pci.ids.patch

--- /usr/share/pci.ids.orig	2014-09-17 08:26:37.194514082 -0700
+++ /usr/share/pci.ids	2014-03-17 12:49:31.000000000 -0700
@@ -14001,6 +14001,8 @@
 	3000  HD-3000
 	5500  HD5500 HDTV
 7284  HT OMEGA Inc.
+7401  EndRun Technologies
+	e100  PTP/IEEE-1588 Slave Clock
 7604  O.N. Electronic Co Ltd.
 7bde  MIDAC Corporation
 7fed  PowerTV
