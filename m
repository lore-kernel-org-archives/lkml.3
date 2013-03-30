Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3C3NGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:06:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3C3NGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:06:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: [PATCH v4 0/6] USB EHCI multiplatform conversion
Date: Sat, 30 Mar 2013 14:04:17 +0100
Message-Id: <1364648663-29296-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:S8YNE/+IJ2UsIqPgL/KjNILjbVMWZ+xlPS2cij+V+XB
 JVO8hzYXf26PdFeCOzAHxs7rNcPDJSjsJAreuaButJlKpUPLPW
 M7pvKbZmZ3pUcW5vyfdTr1a4CMl1aQ3tnMa60tA17m68YU81jl
 xKKVMVqWEA5yxTpwN4l4lRlqUZ82Vrw8KUl2dIb2vDaqeE9yMm
 we+jLzzLQ03jW2zj8VLpEUDx3o9c0BzrFC4DEUUqN64t4fN8Gs
 JUeMH3O4zXcvZnY1x/rDIvlu5OWzTOhrS92XxBwzdLkAmIYm6y
 01EInlpNNloziu+fm/JDWy4IriBHKLRrFRMPlptwqg5C5AnyZI
 1c8IdJnXLczs4SRIXRe1QXl+F/pFuE3dj5Pg9evuiAKoApFwCH
 Ch6M3rG07cM+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

This is a quick update to v3, addressing all issues you pointed in
yesterday's review. Thanks for taking a thorough look on short notice
on a public holiday!

	Arnd

Arnd Bergmann (1):
  USB: OHCI: avoid conflicting platform drivers

Manjunath Goudar (5):
  USB: EHCI: make ehci-orion a separate driver
  USB: EHCI: make ehci-spear a separate driver
  USB: EHCI: make ehci-s5p a separate driver
  USB: EHCI: make ehci-atmel a separate driver
  USB: EHCI: make ehci-msm a separate driver

 drivers/usb/host/Kconfig      |  40 +++++++++--
 drivers/usb/host/Makefile     |   5 ++
 drivers/usb/host/ehci-atmel.c |  88 +++++++++++------------
 drivers/usb/host/ehci-hcd.c   |  30 ++------
 drivers/usb/host/ehci-msm.c   |  85 ++++++++++------------
 drivers/usb/host/ehci-orion.c |  82 +++++++++------------
 drivers/usb/host/ehci-s5p.c   | 164 +++++++++++++++++++++---------------------
 drivers/usb/host/ehci-spear.c | 115 +++++++++++++----------------
 drivers/usb/host/ohci-hcd.c   | 136 ++++++++++++++++++++++++++++++-----
 9 files changed, 408 insertions(+), 337 deletions(-)

-- 
1.8.1.2

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: spear-devel@list.st.com


