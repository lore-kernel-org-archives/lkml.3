Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaDUNsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:48:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42525 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaDUNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:48:19 -0400
Message-ID: <535521A0.5050706@codeaurora.org>
Date: Mon, 21 Apr 2014 09:48:16 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 0/4] Introduce drivers/soc and add QCOM GSBI driver
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
In-Reply-To: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 04/21/2014 01:30 AM, Andy Gross wrote:
> The first patch in this set adds the drivers/soc directory and all the necessary
> plumbing.  These changes were discussed at the kernel summit and also were
> introduced in an earlier patch set from Santosh Shilimkar.
> 
> Reference the following set of patches:
> https://lkml.org/lkml/2014/2/28/567

In that thread, Olof wrote, "The code [going into drivers/soc] isn't the pure
drivers. Those we find homes for."

https://lkml.org/lkml/2014/3/2/123

> The remaining patches add the QCOM GSBI (General Serial Bus Interface) driver,
> device tree binding information for both the GSBI and child node interaction,
> and lastly a patch to fix the current MSM serial driver to work correctly with
> the GSBI changes.

It's not obvious to me what makes the GSBI driver "impure" and unfit for say
drivers/bus. Could you perhaps include a brief explanation?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
