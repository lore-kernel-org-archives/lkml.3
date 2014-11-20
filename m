Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbaKTXYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:24:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbaKTXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:24:52 -0500
Date: Thu, 20 Nov 2014 15:23:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        devel@driverdev.osuosl.org,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Markos Chandras <Markos.Chandras@imgtec.com>
Subject: Re: [PATCH] Revert "staging: sm7xxfb: remove driver"
Message-ID: <20141120232329.GA27669@kroah.com>
References: <20141120170925.5a435436@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120170925.5a435436@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:09:25PM -0500, Steven Rostedt wrote:
> 
> Someone reported a bug in the function graph tracer for MIPS. As I'm
> still waiting on my USB serial for my Imagination MIPS board, I decided
> to bring my Lemote Yeeloong laptop back up to the latest kernel. This
> is where I noticed that the screen no longer displays anything.
> 
> I ran a bisect, which came across a staging commit that removed the
> sm7xxfb driver. When I reverted it on a v3.18-rc5 kernel and booted it
> on my Lemote laptop, the display worked again.
> 
> I then did a search for this commit and found that Debian reverted it
> too. Seems that there's still some Debian users of this laptop. (RMS?)
> 
> What needs to be done to make this a "proper" driver? I can try to
> support it, although I have no idea how it works :-)

Have you read the TODO file in this patch?  If you are willing to work
on this, I'll be glad to apply it, but the reason I removed it was
because no one had done anything with it for a very long time.

It needs a maintainer / developer, otherwise I can't take this.

thanks,

greg k-h
