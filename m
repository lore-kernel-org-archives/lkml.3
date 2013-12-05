Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3LEJzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:55:12 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:37497 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655Ab3LEJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:55:08 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v3 0/3] usb: ohci-at91: various improvements
Date: Thu,  5 Dec 2013 10:54:39 +0100
Message-Id: <1386237282-22385-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 5690298129756616959
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series moves the different driver resources (clks and iomem)
retrieval to the device managed versions (devm_ functions).

Best Regards,

Boris

Changes since v2:
 - split urgent fix and resource retrieval improvements

Boris BREZILLON (3):
  usb: ohci-at91: replace request_mem_region + ioremap by
    devm_request_and_ioremap
  usb: ohci-at91: use dev variable instead of &pdev->dev
  usb: ohci-at91: use device managed clk retrieval

 drivers/usb/host/ohci-at91.c |   64 +++++++++++-------------------------------
 1 file changed, 17 insertions(+), 47 deletions(-)

-- 
1.7.9.5

