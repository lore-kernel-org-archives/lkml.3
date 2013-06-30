Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3F3QKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:10:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3QKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:10:17 -0400
Date: Sun, 30 Jun 2013 09:11:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Richard Corbin <racorbin2010@charter.net>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: A Bug in 3.9.8
Message-ID: <20130630161105.GA4213@kroah.com>
References: <51CF572F.3040400@charter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CF572F.3040400@charter.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 04:52:47PM -0500, Richard Corbin wrote:
> Folks:
> 
> I sent the indented text to gregkh@linuxfoundation.org,
> inappropriately as I suspected. I got a polite automated response
> suggesting alternate destinations for my email. To my non-technical
> eyes, your addresses seemed most appropriate.
> 
>     "Mr. Kroah-Hartman,
> 
>     "Excuse me for bothering you, but I do not know where to report
> my problem and I found your name in
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.9.8-saucy/BUILD.LOG.

My name is there because it's the first commit, for some strange reason
the Ubuntu build logs this, but I have nothing to do with their kernel
builds.

>     "I am running Linux Mint KDE v15, but I like to run the latest
> kernel. I have never had a problem before installing the latest
> "general release" kernel from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/ until yesterday.
> 
>     "After I installed v3.9.8-saucy, the system could no longer
> "read" cpu usage of my quad-core Intel  q6600. Conky, "top", "mpstat
> -P ALL" all show ZERO CPU usage. Everything else is fine; it is just
> the reporting that is busted.
> 
>     "If you are the wrong person and cannot forward to correct
> destination, then I am sorry for wasting your time."
> 
> I neglected to write that when I rebooted the identical system using
> v3.9.7-saucy as the kernel, the CPU usage for each core was
> registering non-zero values when appropriate as usual.

As this is a Ubuntu-specific kernel, I suggest filing a bug in the
Ubuntu bug tracking tool to help resolve this, ther's not much we in the
community can do about this, sorry.

best of luck,

greg k-h
