Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab3FSLwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:52:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41867 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab3FSLwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:52:30 -0400
Message-ID: <51C19B5E.6030907@ti.com>
Date: Wed, 19 Jun 2013 17:21:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] ARM: davinci: da8xx: creation of gpio platform
 device
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com> <1371202532-14628-4-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371202532-14628-4-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:05 PM, Philip Avinash wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> gpio controller resource information being associated with
> davinci_soc_info structure and not created any device. Hence davinci
> gpio didn't fall under proper device model. This patch creates gpio
> davinci as a platform device for da8xx platforms.

I didn't really find the description coherent. I simplified it to:

    ARM: davinci: da8xx: support gpio platform device

    DaVinci GPIO driver now uses platform device model.
    Convert DA8XX SoC code to use the new model.

    - Add Memory and IRQ resources for da8xx
    - Add da8xx_register_gpio API to create platform device for da8xx
      platforms.

    Signed-off-by: KV Sujith <sujithkv@ti.com>
    Signed-off-by: Philip Avinash <avinashphilip@ti.com>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    [nsekhar@ti.com: simplify commit message]
    Signed-off-by: Sekhar Nori <nsekhar@ti.com>

Before applying the patch.

Thanks,
Sekhar
