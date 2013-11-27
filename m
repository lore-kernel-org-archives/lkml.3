Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3K0P1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:27:09 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:50375 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3K0P1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:27:07 -0500
Date: Wed, 27 Nov 2013 15:27:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
Message-ID: <20131127152701.GQ3296@lee--X1>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131127132442.GJ3296@lee--X1>
 <20131127151639.GX14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127151639.GX14725@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Mark Brown wrote:

> On Wed, Nov 27, 2013 at 01:24:42PM +0000, Lee Jones wrote:
> 
> > I'm not keen on this patch going through ASoC, as it might make things
> > equally as awkward later in the cycle. We should have created an
> > immutable branch for that really. I guess this will have to wait for
> > the next cycle now...
> 
> That seems excessive and it probably ought to go in as a bug fix
> afterwards.  Given that it's just an addition of data to the table I'd
> expect we could cope, we've routinely done that with similar updates in
> the past without incident.

Ah, is the depends patch in Mainline already? I assumed it was due to
go in during the v3.14 merge window? If it's already in Mainline, then
sure I don't mind if it goes in -fixes via ASoC, no problem.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
