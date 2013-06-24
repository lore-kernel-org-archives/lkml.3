Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3FXP0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:26:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46158 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3FXP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:26:31 -0400
Message-ID: <51C86524.8020708@wwwdotorg.org>
Date: Mon, 24 Jun 2013 09:26:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: rip out the direct pinconf API
References: <1372079700-16580-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1372079700-16580-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 07:15 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> From the inception ot the pin config API there has been the
> possibility to get a handle at a pin directly and configure
> its electrical characteristics. For this reason we had:
> 
> int pin_config_get(const char *dev_name, const char *name,
>                unsigned long *config);
> int pin_config_set(const char *dev_name, const char *name,
>                unsigned long config);
> int pin_config_group_get(const char *dev_name,
>                const char *pin_group,
>                unsigned long *config);
> int pin_config_group_set(const char *dev_name,
>                const char *pin_group,
>                unsigned long config);
> 
> After the intruction of the pin control states that will
> control pins associated with devices, and its subsequent
> introduction to the device core, as well as the
> introduction of pin control hogs that can set up states on
> boot and optionally also at sleep, this direct pin control
> API is a thing of the past.
> 
> As could be expected, it has zero in-kernel users.
> Let's delete this API and make our world simpler.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
