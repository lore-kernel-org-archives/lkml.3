Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbbA0Az0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:55:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46127 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbA0AzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:55:24 -0500
Message-ID: <54C6E1FB.5030907@codeaurora.org>
Date: Mon, 26 Jan 2015 16:55:23 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v13 0/6] Per-user clock constraints
References: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/15 03:03, Tomeu Vizoso wrote:
> Hi,
>
> in this v13 I have:
>
> * added the latest R-b tags from Stephen,
>
> * split some lines that went over the 80-char limit,
>
> * made explicit in the docs that the range limits are inclusive, and
>
> * removed an ifdef in clkdev.c by adding a dev_id param to __of_clk_get_by_name.
>

I think this patch series is ready to go except for the last one? Do you
plan on polishing that one some more?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

