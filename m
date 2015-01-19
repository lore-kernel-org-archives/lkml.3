Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbbASTTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:19:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44687 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbASTTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:19:19 -0500
Message-ID: <54BD58B5.8010009@codeaurora.org>
Date: Mon, 19 Jan 2015 11:19:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v9 1/3] clk: Remove unneeded NULL checks
References: <1421688067-24426-1-git-send-email-tomeu.vizoso@collabora.com> <1421688067-24426-2-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1421688067-24426-2-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 09:20 AM, Tomeu Vizoso wrote:
> As clk_unprepare_unused_subtree and clk_disable_unused_subtree are
> always called with a valid struct clk.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

thanks.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

