Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3IQJyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:54:15 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58481 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3IQJyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:54:14 -0400
Date: Tue, 17 Sep 2013 10:54:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Update volatile registers for WM5110 DSP
Message-ID: <20130917095407.GV16984@lee--X1>
References: <1379345514-2998-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20130917072425.GP16984@lee--X1>
 <20130917091823.GF3635@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130917091823.GF3635@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No problem sorry the commit message was a little vague there.
> Seems I accidentally generated the first version of this patch
> against the ASoC tree, but this got me thinking now you are
> looking after MFD patches which tree should I be generating them
> against?

That depends. If you are submitting MFD only patches and you base them
on either Sam's [1] or my tree [2], you probably won't go too far
wrong.

However, if your patch or patch-set touches other subsystems then the
latest -rc is usually appropriate.

> On Tue, Sep 17, 2013 at 08:24:25AM +0100, Lee Jones wrote:
> > On Mon, 16 Sep 2013, Charles Keepax wrote:
> > 
> > Any chance of a little more information in the commit message?
> > 
> > What are scratch registers and why are they required now where they
> > weren't before? Why are the control and clocking regulators no longer
> > needed?

[1] git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git - master
[2] git://git.linaro.org/people/ljones/mfd.git - for-mfd-next

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
