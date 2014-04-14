Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaDNRsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:48:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40868 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbaDNRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:48:21 -0400
Message-ID: <534C1F63.1040705@codeaurora.org>
Date: Mon, 14 Apr 2014 10:48:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
CC: Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: debug: qcom: make UART address selection configuration
 option
References: <53458708.40702@codeaurora.org> <1397483254-3612-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1397483254-3612-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/14 06:47, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Separate Qualcomm low-level debugging UART to two options.
>
> DEBUG_MSM_UART is used in earlier non-multi platform arches,
> like MSM7X00A, QSD8X50 and MSM7X30.
>
> DEBUG_QCOM_UARTDM is used in multi-plafrom arches and have
> embedded data mover.
>
> Make DEBUG_UART_PHYS and DEBUG_UART_BASE user adjustable by
> Kconfig menu.
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Looks good. Thanks. I'll give it a test later today. We may still need
to send the small fix for 3.15 if this is too large for rc2.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

