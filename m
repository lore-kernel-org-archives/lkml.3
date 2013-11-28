Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3K1ItM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:49:12 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:51381 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3K1Is7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:48:59 -0500
Date: Thu, 28 Nov 2013 08:48:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
Message-ID: <20131128084854.GY3296@lee--X1>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131127132442.GJ3296@lee--X1>
 <20131127151639.GX14725@sirena.org.uk>
 <20131127152701.GQ3296@lee--X1>
 <20131127160707.GC14725@sirena.org.uk>
 <20131127164202.GX3296@lee--X1>
 <20131127182841.GF14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127182841.GF14725@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I see. Well I'm not sure how. If we apply it to either ASoC or MFD and
> > other patches pertaining to that file subsequently appear, then
> > conflict is likely. As you know, the commonly used mitigation
> 
> It shouldn't be that likely, we're adding entries to the middle of big,
> ordered tables - conflicts would be caused by something like changing
> or adding adjacent entries and they're pretty trivial to resolve.  It's
> not like a restructring of the code or anything.
> 
> > technique we usually employ is immutable branches, but this was not
> > employed in this case for one reason or another. So if we apply it now
> > to either one of the trees we will be hedging our bets.
> 
> Hedging our bets would be applying it to both trees!  

Well I'm sure we'd sort out any conflicts.

Go ahead and apply it to your tree with my Ack then.

In future, let's do the immutable branch thing, it's worked well thus
far.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
