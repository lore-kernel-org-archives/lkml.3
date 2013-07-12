Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab3GLPLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab3GLPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:11:53 -0400
Date: Fri, 12 Jul 2013 08:12:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Gianluca Anzolin <gianluca@sottospazio.it>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix refcount leak in tty_port.c
Message-ID: <20130712151250.GA10499@kroah.com>
References: <20130709083535.GA30227>
 <20130712094733.GA28317@debian.seek.priv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712094733.GA28317@debian.seek.priv>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:47:33AM +0200, Gianluca Anzolin wrote:
> Hello,
> 
> I'm sorry to bother you again, I'm just pinging to see if you received the
> patch or if it got lost in the noise. It fixes a regression introduced in git
> commit aa27a094e2c2e
> 
> I have another patch for rfcomm tty waiting for this fix to get applied.

I have it, just waiting for 3.11-rc1 to come out before dealing with any
new patches.

thanks,

greg k-h
