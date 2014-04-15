Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaDOR4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:56:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38981 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaDOR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:56:15 -0400
Message-ID: <534D72BE.4050300@codeaurora.org>
Date: Tue, 15 Apr 2014 10:56:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: qcom: Consolidate common probe code
References: <1395449977-2401-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1395449977-2401-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/14 17:59, Stephen Boyd wrote:
> Most of the probe code is the same between all the different
> clock controllers. Consolidate the code into a common.c file.
> This makes changes to the common probe parts easier and reduces
> chances for bugs.
>
>

ping?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

