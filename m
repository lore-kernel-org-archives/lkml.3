Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaH2I6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:58:16 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33789 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaH2I6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:58:09 -0400
Date: Fri, 29 Aug 2014 09:58:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH RESEND 0/8] i2c: Relax mandatory I2C ID table passing
Message-ID: <20140829085804.GE24579@lee--X1>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
 <20140829084538.GC1329@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140829084538.GC1329@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014, Wolfram Sang wrote:
> > Placing this firmly back on your plate.  I truly hope we don't miss
> > another merge-window.
> 
> Nope, we won't. I'll still need a week or so due to other duties.

Perfectly reasonable.

> > This patch-set has the support of some pretty
> > senior kernel maintainers, so I hope acceptance shouldn't be too
> > difficult.
> 
> Cool, then they could ack it like Grant did? That surely helps.

I was talking about Grant (and Linus - I'll poke him seperately). ;)

> > As previously discussed I believe it should be okay for an I2C device
> > driver _not_ supply an I2C ID table to match to.
> 
> I agree...
> 
> > The I2C subsystem
> > should be able to match via other means, such as via OF tables.  The
> > blocking factor during our previous conversation was to keep
> > registering via sysfs up and running.  This set does that.
> 
> ... yet it also should not cause regressions. If you fixed that, sounds
> great!
>
> > After thinking more deeply about the problem, it occurred to me that
> > any I2C device driver which uses the sysfs method and issues an
> > of_match_device() would also fail their probe().  Bolted on to this
> > set is a new, more generic way for these devices to match against
> > either of the I2C/OF tables.
> 
> Even better :) I am generally positive with your patchset, but need to
> review the implementation. For core stuff, this simply needs more
> attention.

Agree.

Thanks Wolfram.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
