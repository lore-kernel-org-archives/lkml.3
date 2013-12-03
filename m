Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3LCDgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:36:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3LCDgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:36:12 -0500
Date: Mon, 2 Dec 2013 19:37:12 -0800
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: update MSI attribute file documentation
Message-ID: <20131203033712.GA8525@kroah.com>
References: <20131129031419.GB5889@neilslaptop.think-freely.org>
 <20131129094137.GC3028@redhat.com>
 <20131129175336.GA6152@kroah.com>
 <CAErSpo44sQU2PbufCYF+wzpMtMPC97_FgAMQgruX9Nw3XbmL8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo44sQU2PbufCYF+wzpMtMPC97_FgAMQgruX9Nw3XbmL8g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Now that the MSI modes are now attribute files in sysfs, not
subdirectories, update the documentation to reflect this.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 5210a51c90fd..a3c5a6685036 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -70,18 +70,15 @@ Date:		September, 2011
 Contact:	Neil Horman <nhorman@tuxdriver.com>
 Description:
 		The /sys/devices/.../msi_irqs directory contains a variable set
-		of sub-directories, with each sub-directory being named after a
-		corresponding msi irq vector allocated to that device.  Each
-		numbered sub-directory N contains attributes of that irq.
-		Note that this directory is not created for device drivers which
-		do not support msi irqs
+		of files, with each file being named after a corresponding msi
+		irq vector allocated to that device.
 
-What:		/sys/bus/pci/devices/.../msi_irqs/<N>/mode
+What:		/sys/bus/pci/devices/.../msi_irqs/<N>
 Date:		September 2011
 Contact:	Neil Horman <nhorman@tuxdriver.com>
 Description:
 		This attribute indicates the mode that the irq vector named by
-		the parent directory is in (msi vs. msix)
+		the file is in (msi vs. msix)
 
 What:		/sys/bus/pci/devices/.../remove
 Date:		January 2009
