Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaHUSqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:46:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42569 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaHUSqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:46:30 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1403030217-21554-1-git-send-email-galak@codeaurora.org>
Date: Thu, 21 Aug 2014 13:46:24 -0500
Cc: linux-ide@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Content-Transfer-Encoding: 8BIT
Message-Id: <6726054A-9CF9-4A5C-A98E-4D44A5782076@codeaurora.org>
References: <1403030217-21554-1-git-send-email-galak@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2014, at 1:36 PM, Kumar Gala <galak@codeaurora.org> wrote:

> Add support for the Qualcomm AHCI SATA controller that exists on several
> SoC and specifically the IPQ806x family of chips.  The IPQ806x SATA support
> requires the associated IPQ806x SATA PHY Driver to be enabled as well.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> v3:
> * Added comment about suspend/resume not supported
> * Fixup ahci_platform_init_host for upstream change to interface
> * cleanup error handling of rxoob clk, moved to devm_clk_get/put
> 
> v2:
> * Fixed MODULE_LICENSE to be GPL v2
> 
> drivers/ata/Kconfig     | 10 ++++++
> drivers/ata/Makefile    |  1 +
> drivers/ata/ahci_qcom.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 101 insertions(+)
> create mode 100644 drivers/ata/ahci_qcom.c

Any other comments on these patches?

I’ll send an update that builds against top of tree.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

