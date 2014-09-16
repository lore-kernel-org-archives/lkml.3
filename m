Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaIPCKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:10:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48467 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaIPCJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:09:58 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v4 1/3] ahci-platform: Bump max number of clocks to 5
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1410277008-20242-1-git-send-email-galak@codeaurora.org>
Date: Mon, 15 Sep 2014 19:09:54 -0700
Cc: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FDA51DE0-3F2C-48E3-81B7-5F2ABCEE6F61@codeaurora.org>
References: <1410277008-20242-1-git-send-email-galak@codeaurora.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 9, 2014, at 8:36 AM, Kumar Gala <galak@codeaurora.org> wrote:

> Qualcomm IPQ806x SoCs with SATA controllers need 5 clocks to be enabled.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> (reposted with Hans on list)
> 
> v4:
> * Updated to upstream changes
> 
> drivers/ata/ahci.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Any updates on these patches?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

