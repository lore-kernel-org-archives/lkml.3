Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbaD1Xau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:30:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40311 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbaD1Xaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:30:46 -0400
Message-ID: <535EE4A4.6040208@codeaurora.org>
Date: Mon, 28 Apr 2014 16:30:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: pm8921: Remove pm8xxx API now that sub-devices use
 regmap
References: <1397002455-12854-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1397002455-12854-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/14 17:14, Stephen Boyd wrote:
> The pm8xxx read/write wrappers are no longer necessary now that
> all the sub-device drivers are using the regmap API. Remove it.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Based on Linus' tip as of a7963eb7f4c4 (Merge branch 'for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs, 2014-04-07)

ping?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

