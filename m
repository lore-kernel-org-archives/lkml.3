Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaJIB0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:26:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50886 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJIB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:26:49 -0400
Message-ID: <5435E457.8010506@codeaurora.org>
Date: Wed, 08 Oct 2014 18:26:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] clk: change clk_debugfs_add_file to take a struct
 clk_hw
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com> <1412695334-2608-6-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1412695334-2608-6-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 08:21 AM, Tomeu Vizoso wrote:
> Instead of struct clk, as this should be only used by providers.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

