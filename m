Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3HTSbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:31:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57807 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3HTSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:31:16 -0400
Date: Tue, 20 Aug 2013 11:31:14 -0700
From: David Brown <davidb@codeaurora.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/3] mfd: pm8921: include missing linux/module.h
Message-ID: <20130820183113.GB11028@codeaurora.org>
References: <005201ce9d73$1696e230$43c4a690$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <005201ce9d73$1696e230$43c4a690$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:01:26PM +0900, Jingoo Han wrote:
>Include <linux/module.h> in order to fix the following errors.
>
>drivers/mfd/pm8921-core.c:209:16: error: expected declaration specifiers or '...' before string constant
>drivers/mfd/pm8921-core.c:210:20: error: expected declaration specifiers or '...' before string constant
>drivers/mfd/pm8921-core.c:211:16: error: expected declaration specifiers or '...' before string constant
>drivers/mfd/pm8921-core.c:212:14: error: expected declaration specifiers or '...' before string constant
>
>Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>---
> drivers/mfd/pm8921-core.c |    1 +
> 1 file changed, 1 insertion(+)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
