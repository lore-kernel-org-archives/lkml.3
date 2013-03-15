Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3COUx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:53:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36161 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3COUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:53:56 -0400
Message-ID: <51438A61.2050704@wwwdotorg.org>
Date: Fri, 15 Mar 2013 14:53:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH] pinctrl: document the "GPIO mode" pitfall
References: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 05:07 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Recently as adoption of the pinctrl framework is reaching
> niches where the pins are reconfigured during system sleep
> and datasheets often talk about something called "GPIO mode",
> some engineers become confused by this, thinking that since
> it is named "GPIO (something something)" it must be modeled
> in the kernel using <linux/gpio.h>.

> +static struct pinctrl_map __initdata pinmap[] = {
> +    PIN_MAP_MUX_GROUP("uart", PINCTRL_STATE_DEFAULT", "pinctrl-foo",

Extra trailing " after PINCTRL_STATE_DEFAULT there.

Otherwise, this sounds plausible, so,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
