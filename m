Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967177Ab3E2XRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:17:01 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43641 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965660Ab3E2XQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:16:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tony Prisk <linux@prisktech.co.nz>, Alexey Charkov <alchark@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51973C1D.2080404@prisktech.co.nz>
Cc: VT8500/WM8505 Linux Kernel 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
 <1368825532-30917-5-git-send-email-linux@prisktech.co.nz>
 <CABjd4Yw2LbnaUbQFW_bd_6WRGTA34-Vp_tUC2b4Jczj-MM8x1w@mail.gmail.com>
 <51973C1D.2080404@prisktech.co.nz>
Message-ID: <20130529231649.6058.4589@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 4/4] MAINTAINERS: vt8500: Add clk-vt8500.c to MAINTAINERS file
Date: Wed, 29 May 2013 16:16:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tony Prisk (2013-05-18 01:30:21)
> On 18/05/13 18:40, Alexey Charkov wrote:
> > On 18 May 2013 01:18, "Tony Prisk" <linux@prisktech.co.nz> wrote:
> >> This file has missed being added under ARM/VT8500 ARM ARCHITECTURE,
> >> and is maintained along with the rest of the vt8500 arch code.
> >>
> >> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> >> ---
> >>   MAINTAINERS |    1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 3d7782b..5ab8ccb 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -1283,6 +1283,7 @@ M:        Tony Prisk <linux@prisktech.co.nz>
> >>   L:     linux-arm-kernel@lists.infradead.org (moderated for
> > non-subscribers)
> >>   S:     Maintained
> >>   F:     arch/arm/mach-vt8500/
> >> +F:     drivers/clk/vt8500-vt8500.c
> > This looks like a typo (clk vs. vt8500).
> >
> > Best,
> > Alexey
> >
> eeek - oops.
> 
> Mike,
> 
> Disregard this patch - I will send a more complete one through arm-soc 
> as there are other files missing as well.
> 

Hi Tony,

I've taken patch #1 into clk-fixes.  I took patches #2 & #3 into
clk-next from your previous series posted on May 13, which appear
identical to the ones in this series.  In the future could you put a
"v2" in the patch subject since those patches were re-posted?  It would
have helped me catch it.

I have not taken patch #4.

Does this all sound correct to you?

Thanks,
Mike

> Regards
> Tony P
