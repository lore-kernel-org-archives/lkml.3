Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaHDNvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:51:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34395 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaHDNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:51:12 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@vger.kernel.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, olof@lixom.net,
        sonnyrao@chromium.org, wulf@rock-chips.com, lyz@rock-chips.com,
        jg1.han@samsung.com, hj@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>, devicetree@vger.kernel.org,
        Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-usb@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v3 0/2] Patches to add dr_mode for dwc2
Date: Mon,  4 Aug 2014 21:45:40 +0800
Message-Id: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches enable the dr_mode for the dwc2 usb
controller.  These are split from the patch series adding
rk3288 dwc2 support.

Changes in v3:
- fix the odd spacing in dwc2_hsotg struct
- From Jingoo's suggestion:
    change the commit message

Changes in v2:
- Split out dr_mode and rk3288 bindings.
- put spaces around '+' operator
- expand the comment for dr_mode
- handle dr_mode is USB_DR_MODE_OTG

Kever Yang (2):
  Documentation: dt-bindings: add dt binding info for dwc2 dr_mode
  usb: dwc2: add 'mode' which based on Kconfig select or dts setting

 Documentation/devicetree/bindings/usb/dwc2.txt |  2 ++
 drivers/usb/dwc2/core.c                        | 18 ++++++++++++++++++
 drivers/usb/dwc2/core.h                        |  5 +++++
 drivers/usb/dwc2/platform.c                    | 12 ++++++++++++
 4 files changed, 37 insertions(+)

-- 
1.9.1

