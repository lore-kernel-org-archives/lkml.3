Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161108Ab3DFULm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 16:11:42 -0400
Received: from sauhun.de ([89.238.76.85]:56345 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758634Ab3DFULk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 16:11:40 -0400
Date: Sat, 6 Apr 2013 22:11:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Simon Glass <sjg@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
Message-ID: <20130406201132.GA3936@the-dreams.de>
References: <1360957573-864-1-git-send-email-dianders@chromium.org>
 <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <CAD=FV=UW4wGFqsg2B3MmC24jhnba5PSvCh8Wck-V6iuYk+Xifw@mail.gmail.com>
 <20130329115821.GC6359@the-dreams.de>
 <515F2E28.2090105@wwwdotorg.org>
 <20130406182957.GA11630@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406182957.GA11630@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Very interesting discussion, especially the argument that "we already shipped"
> would not be a convincing argument.
> 
> I had senior kernel maintainers tell me and the company I work for that we should
> submit _all_ our platform specific kernel code and drivers for inclusion into
> the upstream kernel.

Yes, great. Really!

> This exchange suggests that "it is a shipping product" does not count for such
> submissions, and that "Benefit for the kernel" would be the deciding factor
> instead. Which of course is a very vague statement - if code supporting
> Chromebookis is of no benefit for the kernel, support for my company's products
> for sure is much less so.

First, let me state that I did not intend to say that the arbitrator
muxer here has NO benefit for the kernel. I was aware there might be
arguments for that and I wanted some more discussion to make that
clearer to me. Simon's mail was very helpful in that regard and I will
comment on that somewhen later.

Still, I do have problems with "we already shipped it". If the driver is
bad or the underlying concept is fragile, I want the freedom to reject a
patch, product shipped or not. I will be supportive to find a proper
solution, promised. If all fails, there is still staging/ or the
possibility of out-of-tree patches.

> Which kind of leaves me in a bind. On one side I promote that we should submit
> all our kernel code, on the other side there is a very compelling case to be
> made that it won't be accepted anyway. That doesn't make my life easier -

Concentrate on argumenting why the driver is useful and it will be fine.
"we already shipped this" feels a bit like blackmailing to me. And since
most drivers do have well thought reasons for their existance, I'd
primarily like to hear about those.

> essentially since it supports those who say that we should not submit anything
> in the first place. And believe me, there are many of those. 
> 
> Just to give some examples:
> - I2C multiplexers. We have a bunch of those. Looking at this exchange,
>   it doesn't look good to get that code included.

Multiplexers should be easy going, it is the arbitration which is discussed here.
I am open to consider some generic arbitration schemes. What I am reluctant to
do is to allow every board to have its own arbitration scheme. This
would be board support hosted in the I2C directory. Meh.

> It would be nice have to get some well defined guidelines for "acceptable"
> contributions. "Benefit for the kernel" sure isn't one.

I don't think it is possible to write down concrete guidelines for this.
"According to rule 4a) of the guidelines you have to accept my patch"?
That would be a mess, I think.

Regards,

   Wolfram

