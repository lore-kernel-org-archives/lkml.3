Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaGOOvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:51:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37728 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaGOOvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:51:02 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v5 1/2] phy: qcom: Add driver for QCOM IPQ806x SATA PHY
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1403030008-20675-1-git-send-email-galak@codeaurora.org>
Date: Tue, 15 Jul 2014 09:50:56 -0500
Cc: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, sboyd@codeaurora.org,
        b.zolnierkie@samsung.com
Content-Transfer-Encoding: 8BIT
Message-Id: <3ABB6878-6EED-452A-BE5F-4240EA237BF7@codeaurora.org>
References: <1403030008-20675-1-git-send-email-galak@codeaurora.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2014, at 1:33 PM, Kumar Gala <galak@codeaurora.org> wrote:

> Add a PHY driver for uses with AHCI based SATA controller driver on the
> IPQ806x family of SoCs.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> v5:
> * Fix copy/paste error when killing qcom_ipq806x_sata_delay_us
> 
> v4:
> * removed qcom_ipq806x_sata_delay_us as it was only used one
> 
> v3:
> * Added Kconfig HAS_IOMEM dep
> * re-ordered probe function so phy_provider_register is last
> 
> v2:
> * dropped unused dev pointer in struct qcom_ipq806x_sata_phy
> * remove unnecessary reg initializaiton
> * Removed unneeded error message
> * Added remove function to disable the clock
> 
> drivers/phy/Kconfig                 |   7 ++
> drivers/phy/Makefile                |   1 +
> drivers/phy/phy-qcom-ipq806x-sata.c | 206 ++++++++++++++++++++++++++++++++++++
> 3 files changed, 214 insertions(+)
> create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c

any update?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

