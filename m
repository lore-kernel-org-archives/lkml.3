Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaKJKxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:53:10 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:57341 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKJKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:53:08 -0500
Date: Mon, 10 Nov 2014 10:53:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v4 1/3] mfd: max8997: use regmap to access registers
Message-ID: <20141110105302.GV21424@x1>
References: <1398693358-28336-1-git-send-email-r.baldyga@samsung.com>
 <1398693358-28336-2-git-send-email-r.baldyga@samsung.com>
 <20140520161902.GD32025@lee--X1>
 <20140520161948.GE32025@lee--X1>
 <545C9197.3090808@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <545C9197.3090808@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Robert Baldyga wrote:
> It looks like everybody have forgot about this patch series. Is there
> any chance for them to be applied? I can resend patches rebased to last
> next branch.

Yes, I think that would be a good idea.

Although, you are still missing some Acks, so I can't apply it right
away.

> On 05/20/2014 06:19 PM, Lee Jones wrote:
> > On Tue, 20 May 2014, Lee Jones wrote:
> > 
> >>> This patch modifies max8997 driver and each associated function driver,
> >>> to use regmap instead of operating directly on i2c bus. It will allow to
> >>> simplify IRQ handling using regmap-irq.
> >>>
> >>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>>
> >>> [For extcon part]
> >>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> >>>
> >>> [For leds part]
> >>> Acked-by: Bryan Wu <cooloney@gmail.com>
> >>> ---
> >>>  drivers/extcon/extcon-max8997.c     |  31 ++++----
> >>>  drivers/input/misc/max8997_haptic.c |  34 +++++----
> >>>  drivers/leds/leds-max8997.c         |  13 ++--
> >>>  drivers/mfd/Kconfig                 |   1 +
> >>>  drivers/mfd/max8997-irq.c           |  64 +++++++---------
> >>>  drivers/mfd/max8997.c               | 141 ++++++++++++++++-------------------
> >>
> >> Looks to be doing the right things and the diff looks good.
> >>
> >> For the MFD part:
> >>   Acked-by: Lee Jones <lee.jones@linaro.org>
> > 
> > I should add that I'd like this to go through the MFD tree.
> > 
> > I can supply the other maintainers with a pull-request as required.
> > 
> >>>  drivers/power/max8997_charger.c     |  33 +++++----
> >>>  drivers/regulator/max8997.c         |  87 +++++++++++-----------
> >>>  drivers/rtc/rtc-max8997.c           |  56 +++++++-------
> >>>  include/linux/mfd/max8997-private.h |  17 ++---
> >>>  10 files changed, 228 insertions(+), 249 deletions(-)
> >>
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
