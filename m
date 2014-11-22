Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856AbaKVHCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 02:02:13 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51746 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaKVHCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 02:02:12 -0500
Date: Sat, 22 Nov 2014 12:32:02 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Markos Chandras <Markos.Chandras@imgtec.com>
Subject: Re: [PATCH] Revert "staging: sm7xxfb: remove driver"
Message-ID: <20141122070202.GB4490@sudip-PC>
References: <20141120170925.5a435436@gandalf.local.home>
 <20141120232329.GA27669@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120232329.GA27669@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:23:29PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 20, 2014 at 05:09:25PM -0500, Steven Rostedt wrote:
> > 
> > Someone reported a bug in the function graph tracer for MIPS. As I'm
> > still waiting on my USB serial for my Imagination MIPS board, I decided
> > to bring my Lemote Yeeloong laptop back up to the latest kernel. This
> > is where I noticed that the screen no longer displays anything.
> > 
> > I ran a bisect, which came across a staging commit that removed the
> > sm7xxfb driver. When I reverted it on a v3.18-rc5 kernel and booted it
> > on my Lemote laptop, the display worked again.
> > 
> > I then did a search for this commit and found that Debian reverted it
> > too. Seems that there's still some Debian users of this laptop. (RMS?)
> > 
> > What needs to be done to make this a "proper" driver? I can try to
> > support it, although I have no idea how it works :-)
> 
> Have you read the TODO file in this patch?  If you are willing to work
> on this, I'll be glad to apply it, but the reason I removed it was
> because no one had done anything with it for a very long time.
> 
> It needs a maintainer / developer, otherwise I can't take this.

i will like to help in this. Silicon Motion is still having SM712 in its product line and SM718 might also be a similar one.

now the problems (as i see) for me to help in the driver :
1) i am a newbie. though i have learnt a lot from the patches i sent , but still I am a newbie.
2) most important - I do not have the hardware. So from the TODO list dual head and 2D acceleration support will be tough without actually checking on the hardware.

thanks
sudip

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
