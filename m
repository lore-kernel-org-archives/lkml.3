Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251Ab3FTJZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:25:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47538 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965172Ab3FTJZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:25:07 -0400
Message-ID: <51C2CA51.5030705@ti.com>
Date: Thu, 20 Jun 2013 14:54:33 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilipk@gmail.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: davinci: fix for build breakage for tnetv107x
 platforms
References: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com> <1371203869-16308-2-git-send-email-avinashphilipk@gmail.com>
In-Reply-To: <1371203869-16308-2-git-send-email-avinashphilipk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:27 PM, Philip Avinash wrote:
> Fix the following build breakage and section mismatch error. This build
> break will comes only on removal of NEED_MACH_GPIO_H select option for
> ARCH-DAVINCI.
> 
> arch/arm/mach-davinci/board-tnetv107x-evm.c:283:15: error:
> 'davinci_timer_init' undeclared here (not in a function)
> arch/arm/mach-davinci/board-tnetv107x-evm.c:285:15: error:
> 'davinci_init_late' undeclared here (not in a function)
> make[1]: *** [arch/arm/mach-davinci/board-tnetv107x-evm.o] Error 1

Can you note the section mismatch error you saw too?

Thanks,
Sekhar
