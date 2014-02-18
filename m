Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaBRNXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:23:33 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:33014 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbaBRNWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:22:47 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 0/3] usb: chipidea: msm: Clean and fix glue layer driver
Date: Tue, 18 Feb 2014 15:21:18 +0200
Message-Id: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

This series intend to fix driver, which was broken for a while. 
It is used to create peripheral role device, which in coordination
with phy-usb-msm driver will provide USB2.0 gadget support for
Qualcomm targets.

Changes since initial version.

 - Address comments from Peter - better description of the changes.
 - Drop patch 4 - till USB PHY driver is ready 

Ivan T. Ivanov (3):
  usb: chipidea: msm: Add device tree binding information
  usb: chipidea: msm: Add device tree support
  usb: chipidea: msm: Initialize offset of the capability registers

 .../devicetree/bindings/usb/msm-hsusb.txt          |   17 ++++++++++++++
 drivers/usb/chipidea/ci_hdrc_msm.c                 |   24 +++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

-- 
1.7.9.5

