Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaIBXY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:24:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44595 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbaIBXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:24:56 -0400
Message-ID: <540651C6.1000000@codeaurora.org>
Date: Tue, 02 Sep 2014 17:24:54 -0600
From: Jeffrey Hugo <jhugo@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Eric Holmberg <eholmber@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v3] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
References: <1409688246-16530-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1409688246-16530-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/2014 2:04 PM, Bjorn Andersson wrote:
> From: Kumar Gala <galak@codeaurora.org>
>
> Add driver for Qualcomm Hardware Mutex block that exists on newer
> Qualcomm SoCs.
>
> Cc: Jeffrey Hugo <jhugo@codeaurora.org>
> Cc: Eric Holmberg <eholmber@codeaurora.org>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> [bjorn: added pm_runtime calls, from Courtney,
> 	added sfpb-mutex compatible,
> 	updated DT binding documentation formatting,
> 	based stride on resource size instead of hardcoded values,
> 	replaced msm prefix with qcom,
> 	cleaned up includes]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
<snip>

For what its worth, this looks good to me.

Jeffrey Hugo
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation.
