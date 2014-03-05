Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaCETqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:46:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:32992 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaCETqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:46:16 -0500
Message-ID: <53177F06.9030605@codeaurora.org>
Date: Wed, 05 Mar 2014 11:46:14 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: pm8921: fixup probe() error path when irq invalid
References: <1394048065-14200-1-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1394048065-14200-1-git-send-email-joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/14 11:34, Josh Cartwright wrote:
> platform_get_irq() returns a negative error code when an IRQ is invalid
> or unspecified.  Make 'irq' signed to properly handle this.
>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

