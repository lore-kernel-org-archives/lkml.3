Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3FLN1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:27:21 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40877 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3FLN1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:27:20 -0400
Date: Wed, 12 Jun 2013 14:27:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, mike.turquette@linaro.org,
        grant.likely@linaro.org, ulf.hansson@linaro.org
Subject: Re: [PATCH 00/32] ARM: ux500: Enable clocks for Device Tree
Message-ID: <20130612132713.GE4320@laptop>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After this patchset has been applied, we can request clocks directly
> from Device Tree without using any AUXDATA device-name hacks. We also
> take care to remove all of thos at the end of the set.

So it looks like Mike and Grant have okayed the actual design of this
patch-set, which is great. Is there any chance on some proper Acks from
Linus and Mike please?

I guess it would be best if this went in via Linus' tree as a compete
patch-set?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
