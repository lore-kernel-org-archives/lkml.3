Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaEFTly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:41:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41074 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaEFTls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:41:48 -0400
Date: Tue, 6 May 2014 12:41:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: debug: qcom: make UART address selection
 configuration option
Message-ID: <20140506194146.GG20486@codeaurora.org>
References: <53458708.40702@codeaurora.org>
 <1397483254-3612-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397483254-3612-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Ivan T. Ivanov wrote:
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
> ---

Finally got around to testing this out.

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
