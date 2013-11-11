Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3KKNnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:43:51 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54328 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3KKNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:43:43 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2013 08:43:42 EST
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: alexander.shishkin@linux.intel.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 0/4] usb: chipidea: msm: Clean and fix glue layer driver
Date: Mon, 11 Nov 2013 15:35:33 +0200
Message-Id: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

This series intend to fixup driver, which was broken for a while. It is 
used to create peripheral role device, which in coordination with
phy-usb-msm driver (still some cleanups pending) will provide again
USB2.0 gadget support for MSM targets.

Generated on to top of usb-3.13-rc1.

Regards,
Ivan

Ivan T. Ivanov (4):
  usb: chipidea: msm: Add device tree binding information
  usb: chipidea: msm: Add device tree support
  usb: chipidea: msm: Initialize offset of the capability registers
  usb: chipidea: msm: Use USB PHY API to control PHY state

 .../devicetree/bindings/usb/msm-hsusb.txt          |   16 ++++++++++
 drivers/usb/chipidea/ci_hdrc_msm.c                 |   33 +++++++++++++++-----
 2 files changed, 41 insertions(+), 8 deletions(-)

-- 
1.7.9.5

