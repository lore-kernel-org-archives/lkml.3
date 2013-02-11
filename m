Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3BKIW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:22:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3BKIWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:22:34 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Various PCI-related device tree helpers
Date: Mon, 11 Feb 2013 09:22:16 +0100
Message-Id: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:1TlqmnomG7nMubDKUJSTyHNVxnmcHV8cC8CS5nwoS9h
 mndUc0JJ3naaaUlRA2/1dFUPGY9c0TLaWo3SQlT+ZqNI4eHeUL
 yVvdkiS6EZ2y4rN3Omd9gVr7wKDbz9ZPEg7v3lVSLspV5R/fFA
 sjc3c78X4J5qM0Wr/G6ov+yFFrQ2WvhXxYmTGfoTQVrgyF04xd
 5t8xGzW774yuRr4M1qbHWkWeUW2FcDr46/ToB/zFMAaOYfKm3x
 5WgVYfFL1HMghAXi+jLMQMNK+3O4Q9AZDGCYUp5yksFSPcDXgw
 A3SNzHApyevahJmEoHK3EWNlLfswGCbDzotimebTgwpUbQPruM
 g58E0kiYLhK3npUOWpiWdJqafspDLhXgJsf0Jg8vOtvdTOmToA
 gHKju2utcIb/Uz61/e0KMPzsF2xnH0rf+WDI0sDrwWArVb0EEe
 0bulY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add a few device tree helpers that are used are partially
shared by Thomas' Marvell PCIe controller and my Tegra PCIe controller
series. In an attempt to decrease the number of dependencies between
trees, it would be nice to get these in for 3.9. There are a few ARM
specific patches that the series depend on which have also been
submitted and will hopefully make it into 3.9 so we can use the 3.9
cycle to focus on getting the driver patches merged.

Thierry

Andrew Murray (1):
  of/pci: Provide support for parsing PCI DT ranges property

Thierry Reding (3):
  of/pci: Add of_pci_get_devfn() function
  of/pci: Add of_pci_get_bus() function
  of/pci: Add of_pci_parse_bus_range() function

 drivers/of/address.c       | 63 ++++++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c        | 80 +++++++++++++++++++++++++++++++++++++++++++---
 include/linux/of_address.h |  9 ++++++
 include/linux/of_pci.h     |  3 ++
 4 files changed, 150 insertions(+), 5 deletions(-)

-- 
1.8.1.2

