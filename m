Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaIKVEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:04:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57302 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaIKVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:04:52 -0400
Message-ID: <54120E6B.4090704@gmail.com>
Date: Thu, 11 Sep 2014 23:04:43 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linus.walleij@linaro.org
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: berlin: fix the dt_free_map function
References: <1410340551-24023-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1410340551-24023-1-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 11:15 AM, Antoine Tenart wrote:
> The berlin_pinctrl_dt_free_map function tries to free memory
> allocated and handled by the of subsystem. This is wrong and
> already handled by pinctrl_dt_free_maps() which calls
> of_node_put().
> 
> This patch fixes the Berlin pinctrl way of freeing its maps,
> avoiding a kernel BUG(), by using the common
> pinctrl_utils_dt_free_map function instead.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/pinctrl/berlin/berlin.c | 21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)

I like the diffstat :)

I am very short on time, so if it works for you, I am fine with it.

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Sebastian
