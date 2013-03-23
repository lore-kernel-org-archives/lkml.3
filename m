Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3CWEGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:06:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59528 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3CWEGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:06:52 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-31-514d2a5b5ccb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
In-reply-to: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
Subject: [PATCH 3/6] pci: infrastructure to add drivers in drivers/pci/host
Date: Sat, 23 Mar 2013 13:06:50 +0900
Message-id: <00c201ce277b$d88be2f0$89a3a8d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ne5IlJNJTIxgLT4K5aVV6JypTrgAACf3A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zfd1oLd9Ag9tL2S2a/29ntVjSlGFx
	YPZDVotXZzayWVxeeInV4vsNU4veBVfZLDY9vsZqcXnXHDaLs/OOs1nMOL+PyWJF01ZGi8UX
	lzNb7F65hMXi2IwljBZPHzQxOQh4rJm3htGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9Y
	yOjxfUcvUMGWVYweP1/qeHzeJBfAHcVlk5Kak1mWWqRvl8CVceaBSME97oon8+6zNjA+5Oxi
	5OSQEDCRWPOzixHCFpO4cG89G4gtJLCMUWLGOv8uRg6wmvYP1V2MXEDh6YwSjat2MEPU/GKU
	ONAnCmKzCahJfPlymB3EFhHwl7h2tZUFpIFZ4DOLxPLJZ9ghGmwl7p6cC9bMKWAn8bgVpIiT
	Q1jAW2LVifdgNSwCqhKNm+aygCzmBaqfucUUJMwrICjxY/I9sHJmAS2J9TuPM0HY8hKb17xl
	hrhTXeLRX12IE4wkFjU2MEKUiEjse/GOEeQcCYErHBLXnkD8yyIgIPFt8iEWiF5ZiU0HmCHB
	IClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZI
	CunfwXj3gPUhxmSg9ROZpUST84EpKK8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjBuimlZEn1TLOjMr2XD+rKtHX9kzPljjU7o5yzhOQOjQ7dpQ
	ifLz8u0RfPPyjcTLr4SK7/tRsYg5I9n+KG+MhG1y5var544uSynlevyjsDeT3eVWUknvkgVX
	tv2SDuS+s6Nn5+JkDofLP5fNk63P9iz5Wyab62m1qmlj8xq7DtZVy31ykiQClFiKMxINtZiL
	ihMBRVmc+jcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoG60lm+gwcI4i+b/21ktljRlWByY
	/ZDV4tWZjWwWlxdeYrX4fsPUonfBVTaLTY+vsVpc3jWHzeLsvONsFjPO72OyWNG0ldFi8cXl
	zBa7Vy5hsTg2YwmjxdMHTUwOAh5r5q1h9OibcpXN48mmi4weCzaVety5tofNY/OSeo/zMxYy
	enzf0QtUsGUVo8fPlzoenzfJBXBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gA9o6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGPMOPNApOAed8WTefdZGxgfcnYxcnBICJhItH+o7mLkBDLFJC7cW8/WxcjFISQwnVGicdUO
	ZpCEkMAvRokDfaIgNpuAmsSXL4fZQWwRAX+Ja1dbWUAamAU+s0gsn3yGHaLBVuLuyblgzZwC
	dhKPW0GKODmEBbwlVp14D1bDIqAq0bhpLgvIEbxA9TO3mIKEeQUEJX5MvgdWziygJbF+53Em
	CFteYvOat8wQN6tLPPqrC3GCkcSixgZGiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWM
	oqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQnqmfQOxlUNFocYBTgYlXh4A6p9AoVYE8uKK3MP
	MUpwMCuJ8N7T8A0U4k1JrKxKLcqPLyrNSS0+xJgM9OdEZinR5Hxg8swriTc0NjEzsjQyszAy
	MTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZoiZVvXfb5/euSrZuW7bxDovt4utSS
	S3/mPLkhdO1/W2LoxEx+/7STLHf4yr8cOxaye/dGU5+2Mq07bAax0pUbOeNSXnp8ztrByM4c
	+OSe9+TPVfs7k1NMjhW0Bkg1bdv8aUrsDdHLZ+WN1d5PWnd2RrZd7Nfm/v/dvs3nVswr+PXo
	0u+sEmclluKMREMt5qLiRACItWGJlAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

As agreed by the community, PCI host drivers will now be stored in
drivers/pci/host. This commit adds this directory and the related
Kconfig/Makefile changes to allow new drivers to be added in this
directory.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pci/Kconfig      |    2 ++
 drivers/pci/Makefile     |    3 +++
 drivers/pci/host/Kconfig |    4 ++++
 3 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/host/Kconfig

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 6d51aa6..ac45398 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -119,3 +119,5 @@ config PCI_IOAPIC
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
+
+source "drivers/pci/host/Kconfig"
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 0c3efcf..6ebf5bf 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -67,3 +67,6 @@ obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
 obj-$(CONFIG_OF) += of.o
 
 ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
+
+# PCI host controller drivers
+obj-y += host/
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
new file mode 100644
index 0000000..cc3a1af
--- /dev/null
+++ b/drivers/pci/host/Kconfig
@@ -0,0 +1,4 @@
+menu "PCI host controller drivers"
+	depends on PCI
+
+endmenu
-- 
1.7.2.5


