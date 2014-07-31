Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaGaAbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:31:07 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:47153 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbaGaAbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:31:04 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: paulz@synopsys.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <37355137e001750c0431682884c255b3>
X-DNS-TYPE: 1
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@vger.kernel.org,
        Kever Yang <kever.yang@rock-chips.com>, devicetree@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 0/2] Patches to add dr_mode for dwc2
Date: Wed, 30 Jul 2014 17:29:15 -0700
Message-Id: <1406766558-8156-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <963258>
References: <963258>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches enable the dr_mode for the dwc2 usb
controller.  These are split from the patch series adding
rk3288 dwc2 support.

Changes in v2:
- Split out dr_mode and rk3288 bindings.
- put spaces around '+' operator
- expand the comment for dr_mode
- handle dr_mode is USB_DR_MODE_OTG

Kever Yang (2):
  Documentation: dt-bindings: add dt binding info for dwc2 dr_mode
  usb: dwc2: add dr_mode support for dwc2

 Documentation/devicetree/bindings/usb/dwc2.txt |    2 ++
 drivers/usb/dwc2/core.c                        |   18 ++++++++++++++++++
 drivers/usb/dwc2/core.h                        |    5 +++++
 drivers/usb/dwc2/platform.c                    |    4 ++++
 4 files changed, 29 insertions(+)

-- 
1.7.9.5


