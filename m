Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3D0AMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:12:16 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40169 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3D0AMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:12:15 -0400
Date: Fri, 26 Apr 2013 17:12:10 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] clocksource: nomadik-mtu: fix up clocksource/timer
Message-ID: <20130427001210.GA1714@quad.lixom.net>
References: <1366463287-9922-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdYWSM0BK77qWbQWh0xsN+Ps95Q70zG-GE98MYvThrky2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYWSM0BK77qWbQWh0xsN+Ps95Q70zG-GE98MYvThrky2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 03:19:43PM +0200, Linus Walleij wrote:
> ARM SoC folks:
> 
> On Sat, Apr 20, 2013 at 3:08 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 
> > The Nomadik clocksource driver has had a bad define making it
> > impossible to use it for sched_clock() for a while. Fix this
> > and also enable it for the Nomadik.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> This one should go to fixes ASAP, could you pick it to your fixes
> branch? It could be tagged stable if desired - this only affects the
> Nomadik which works just OK on jiffies so it's really no big regression.
> The Ux500 does not use the MTU for sched_clock().

Ok, applied on top of next/multiplatform, seems to be what it's based on.

Tagging as stable is up to you as platform owner. :) Since it won't directly
apply to older kernels you might be better of submitting it to Greg separately.


-Olof
