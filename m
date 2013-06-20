Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab3FTJXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:23:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58911 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab3FTJX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:23:28 -0400
Message-ID: <51C2C9ED.7070409@ti.com>
Date: Thu, 20 Jun 2013 14:52:53 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilipk@gmail.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Fix build breakage for tnetv107x platforms
References: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
In-Reply-To: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:27 PM, Philip Avinash wrote:
> tnetv107x_defconfig build failing on removal selection of NEED_MACH_GPIO_H
> for ARCH_DAVINCI. This is due to header files inclusion from mach/gpio-davinci.h
> So this patch series fixes the build breakage on removal of NEED_MACH_GPIO_H.

So does this mean at the end of 7/7 of your "Convert GPIO Davinci to
platform driver" series, the build is broken?

If yes, then please include them when you repost that series before 7/7.
Having a patch break build is bad.

Thanks,
Sekhar
