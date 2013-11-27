Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3K0OTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:19:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59358 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab3K0OTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:19:20 -0500
Date: Wed, 27 Nov 2013 14:19:18 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
	as readable
Message-ID: <20131127141918.GA10013@opensource.wolfsonmicro.com>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20131127132442.GJ3296@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127132442.GJ3296@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 01:24:42PM +0000, Lee Jones wrote:
> > The registers associated with the new channels on AIF2 were accidentally
> > missing defaults and not marked as readable this patch fixes this.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> > 
> > This patch depends on the patch:
> > 
> > "ASoC: wm5110: Add extra AIF2 channels"
> > 
> > Which is going through the ASoC tree at the moment, so
> > probably best to send this patch through the ASoC tree as
> > well. As such I have generated it against Mark's for-next
> > branch, let me know if it needs regenerating.
> 
> Hmm... this is awkward!
> 
> I'm not keen on this patch going through ASoC, as it might make things
> equally as awkward later in the cycle. We should have created an
> immutable branch for that really. I guess this will have to wait for
> the next cycle now...

To be honest there is no urgent rush to get this in so it can
wait until the next cycle, I will just have to make sure I
remember to resend.

Thanks,
Charles
