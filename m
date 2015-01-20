Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbbATXdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:33:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60038 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbbATXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:33:43 -0500
Message-ID: <54BEE5D6.2060707@codeaurora.org>
Date: Tue, 20 Jan 2015 15:33:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Export phase functions
References: <1421789023-3128-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1421789023-3128-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 01:23 PM, Maxime Ripard wrote:
> The phase setter and getter were not exported until now, which was causing
> build breakages when callers were compiled as module. Export these two
> functions.
>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

