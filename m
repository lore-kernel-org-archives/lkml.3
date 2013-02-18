Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3BRCFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 21:05:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55515 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3BRCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 21:05:39 -0500
Date: Sun, 17 Feb 2013 18:05:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Andrews <jon@jonshouse.co.uk>
Cc: anish kumar <anish198519851985@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Stupid user with user-space questions, matrix LED driving with
 user space code only.
Message-ID: <20130218020557.GA27667@kroah.com>
References: <1361025476.4271.36.camel@jonspc>
 <1361082134.16206.24.camel@anish-Inspiron-N5050>
 <1361111844.14757.29.camel@jonspc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361111844.14757.29.camel@jonspc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 02:37:24PM +0000, Jonathan Andrews wrote:
> From a user perspective it seems a bit crap to have to change the kernel
> if you have a workload that preemption is harmful to.  
> In the case of something like the Raspberry Pi changing the kernel if
> the distribution has not done the work for me sounds like real effort.
> The kernel is tied to binary obscurity from broadcom... To build I need
> a working cross compiler, toolchain, kernel sources, Pi specific patches
> then to get everything in the correct place on an SD card containing two
> filesystems.  Its possible but its not going to "just work" at my skill
> level....

As you can not boot a kernel.org kernel on the RPI platform just yet,
there's very little that the kernel.org community can do here to help
you out.  I suggest you go take this up with the developers whom you got
this specific kernel build from, there's nothing we can do here about
it.

Best of luck,

greg k-h
