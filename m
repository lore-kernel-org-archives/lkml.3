Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaJUSbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:31:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47252 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaJUSbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:31:33 -0400
Message-ID: <5446A683.1020904@codeaurora.org>
Date: Tue, 21 Oct 2014 11:31:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/8] clk: Don't try to use a struct clk* after it could
 have been freed
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com> <1413812442-24956-4-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1413812442-24956-4-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 06:40 AM, Tomeu Vizoso wrote:
> As __clk_release could call kfree on clk and then we wouldn't have a safe way
> of getting the module that owns the clock.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Fixes: fcb0ee6a3d33 ("clk: Implement clk_unregister")

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

