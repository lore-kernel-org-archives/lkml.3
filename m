Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab3HGVcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab3HGVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:32:04 -0400
Date: Wed, 7 Aug 2013 14:33:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130807213325.GB5373@kroah.com>
References: <20130803223828.GA14611@kroah.com>
 <51FECDA6.5070001@linuxtoys.org>
 <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202B674.7060005@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202B674.7060005@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:04:52PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> >>	cat /dev/proxyctrl   # what is the offset?
> >>	echo 2 > /dev/proxyctrl  # set offset to 2
> >
> >You have language bindings right there in bash for this api, what you
> >are saying is that you don't want to write new syscall bindings for new
> >languages, which is fine, don't do that, use the ones we already have
> >for the vast number of different IPC types.
> 
> You are correct.  There very much is a protocol in use.  Just as
> there is for setting ip_forward in /proc.  And from your previous
> comment, it doesn't have to be ASCII.  It could be binary or XML.

You are mixing protocols and bindings and system calls up it seems.
They are not the same at all.

> >What is your specific requirements, I see you couch them in terms of
> >what you have created, but none in terms of actual requirements with no
> >specific implementation.
> 
> You are correct.  I have been giving them in terms of my goal. The
> title still captures it: "a simple device to give daemons a /sys-like
> interface".

Again, /sys and /proc is talking to the kernel, not userspace to
userspace, I still fail to understand how you will do that to create a
"userspace" driver.

> I am not a kernel programmer.  I am an Electrical Engineer trying to
> control a robot. So I don't know what you mean by "actual requirements"
> or a "specific implementation".   If you point me at a working example
> I'll be happy to try to provide these.

How can you control a robot with this code?

What do you want to do in order to control your robot?  What are your
needs in accessing the hardware?  What hardware are you wanting to
control?  And why can't you just access that hardware through the normal
kernel apis we have today?

thanks,

greg k-h
