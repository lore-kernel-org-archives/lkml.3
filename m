Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaE2TTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:19:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaE2TTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:19:09 -0400
Message-ID: <53878829.4050703@wwwdotorg.org>
Date: Thu, 29 May 2014 13:19:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: fwu@marvell.com, linus.walleij@linaro.org, tony@atomide.com
CC: linux-kernel@vger.kernel.org, swarren@nvidia.com, cxie4@marvell.com,
        ylmao@marvell.com, njiang1@marvell.com, tianxf@marvell.com,
        fswu@marvell.com
Subject: Re: [PATCH v3] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401072217-3180-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1401072217-3180-1-git-send-email-fwu@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2014 08:43 PM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
> 
> What the patch did:
> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>   calling pinctrl_select_state
> 2.Remove the HW disable operation in in pinmux_disable_setting function.
...

This commit description is way too long for such a simple change. A much
shorter summary would be better.

> Signed-off-by: Fan Wu <fwu@marvell.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

I'm pretty sure I never signed off on this patch. How come my s-o-b line
is there?

This patch still doesn't remove ops->disable from the struct pinmux_ops,
nor any of its implementations. Shouldn't it?
