Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaKCWmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:42:35 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34687 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaKCWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:42:32 -0500
Date: Mon, 3 Nov 2014 22:42:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Chris Zhong <zyw@rock-chips.com>,
        Zhang Qing <zhangqing@rock-chips.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 19/47] mfd: rk808: Register power-off handler with
 kernel power-off handler
Message-ID: <20141103224227.GF13359@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-20-git-send-email-linux@roeck-us.net>
 <20141103175346.GI12011@x1>
 <20141103190602.GE10558@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141103190602.GE10558@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Guenter Roeck wrote:

> On Mon, Nov 03, 2014 at 05:53:46PM +0000, Lee Jones wrote:
> > On Mon, 27 Oct 2014, Guenter Roeck wrote:
> > 
> > > Register with kernel power-off handler instead of setting pm_power_off
> > > directly. Register with low priority to reflect that the original code
> > > only sets pm_power_off if it was not already set.
> > > 
> > > Cc: Chris Zhong <zyw@rock-chips.com>
> > > Cc: Zhang Qing <zhangqing@rock-chips.com>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > > v3:
> > > - Replace poweroff in all newly introduced variables and in text
> > >   with power_off or power-off as appropriate
> > > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > > v2:
> > > - New patch
> > > 
> > >  drivers/mfd/rk808.c       | 30 ++++++++++++++++--------------
> > >  include/linux/mfd/rk808.h |  2 ++
> > >  2 files changed, 18 insertions(+), 14 deletions(-)
> > 
> > Code looks okay:
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > 
> Thanks!
> 
> > ... but how are you thinking about handling this set?
> > 
> 
> Plan is to send the entire series directly to Linus in the next
> commit window, as suggested by several of the affected maintainers.
> 
> I am still missing an Ack for patch 1 of the series. If/when I get
> that, I'll set up the series except for the last patch to be added
> to linux-next for it to get some exposure.
> 
> Of course, that plan may all fall apart if someone objects. In that case,
> the patches would have to be taken over several releases by the individual
> maintainers.

Very well.  Either is okay with me.  It might also be worth
considering speaking to Linus and requesting permission to send during
-rc1 to minimise the risk of a huge number of conflicts.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
