Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031276Ab3HIVwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:52:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031258Ab3HIVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:52:33 -0400
Date: Fri, 9 Aug 2013 14:52:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130809215231.GA21756@kroah.com>
References: <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202B674.7060005@linuxtoys.org>
 <20130807213325.GB5373@kroah.com>
 <52040C3A.9090708@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52040C3A.9090708@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 02:23:06PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:>
> > You are mixing protocols and bindings and system calls up it seems.
> > They are not the same at all.
> 
> > How can you control a robot with this code?
> > What do you want to do in order to control your robot?  What are your
> > needs in accessing the hardware?  What hardware are you wanting to
> > control?  And why can't you just access that hardware through the normal
> > kernel apis we have today?
> 
> 
> Greg
>     I'll reply again to this message but for now let me try
> another explanation that does not mention sysfs, procfs, or
> device drivers.   This is probably how I should have started.

I fail to understand how you will use this code to write a "userspace
device driver" at all.

still confused,

greg k-h
