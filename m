Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaDVM6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:58:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59733 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaDVM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:58:40 -0400
Message-ID: <53566778.5090603@codeaurora.org>
Date: Tue, 22 Apr 2014 08:58:32 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: srinivas.kandagatla@linaro.org
CC: linux-mmc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 00/12] Add Qualcomm SD Card Controller support.
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini,

On 04/21/2014 05:43 PM, srinivas.kandagatla@linaro.org wrote:

> This patches are tested in PIO mode on IFC8064 board with both eMMC and
> external SD card. I would appreciate any feedback/suggestions on the overall
> approach.

Is a non-upstream device tree needed to reproduce your test setup? If so could
you please point to or post it?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
