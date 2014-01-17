Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaAQRq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:46:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAQRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:46:26 -0500
Message-ID: <52D96C6F.7090608@codeaurora.org>
Date: Fri, 17 Jan 2014 12:46:23 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: msm: fix compilation errors when !CONFIG_PM_SLEEP
References: <20140117132232.GC15937@n2100.arm.linux.org.uk> <1389979580-14812-1-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1389979580-14812-1-git-send-email-joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 01/17/2014 12:26 PM, Josh Cartwright wrote:

[...]

> @@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
>  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
>  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
>  
> -#ifdef CONFIG_PM_SLEEP
> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)

Why not #ifdef CONFIG_PM here?

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
