Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaFJRbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:31:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54851 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaFJRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:31:37 -0400
Message-ID: <539740F5.9030204@codeaurora.org>
Date: Tue, 10 Jun 2014 10:31:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] ARM: qcom: select GSBI from mach kconfig
References: <1402398980-24664-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1402398980-24664-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 04:16, Srinivas Kandagatla wrote:
> This patch adds GSBI selection automatically from mach kconfig, As GSBI
> seems to be the very basic SOC specific driver and serial driver depends on it.
> I think this option should be selected via mach kconfig rather than adding
> it to any defconfig.
>
> Without this patch multi_v7_defconfig can not show up console on
> IFC6410.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>

No, we should be getting rid of selects, not adding more. Just put this
in the multi_v7_defconfig.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

