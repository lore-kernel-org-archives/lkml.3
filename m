Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaBEArg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:47:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40663 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaBEAre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:47:34 -0500
Date: Tue, 4 Feb 2014 16:47:33 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Split mach-msm into legacy and mach-qcom
 (multiplatform)
Message-ID: <20140205004732.GB12815@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391553532-27001-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Kumar Gala wrote:
> This is the splits the Qualcomm MSM platform into legacy support that we will
> not try and convert to multiplatform and multiplatform support.
> 
> - k
> 
> Changes from v1:
> * Added patch to remove hotplug.c
> * Added patch to rename msm_ to qcom_
> * Changes the Kconfig to drop CPU_V7
> * used wfi() in cpu_die function
> * Added git tree to MAINTAINERS file

What's the plan for this series combined with my SMP series? It
looks like this isn't based on those patches, so we'll have some
conflicts with the msm to qcom rename but it should be fairly
minor.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
