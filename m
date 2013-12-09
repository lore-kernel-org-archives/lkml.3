Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294Ab3LISjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:39:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3LISjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:39:17 -0500
Date: Mon, 9 Dec 2013 10:40:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/debugfs: Check debugfs initialization before using it
Message-ID: <20131209184050.GC28986@kroah.com>
References: <1386502262-1163-1-git-send-email-ethan.kernel@gmail.com>
 <20131208140100.GA22793@kroah.com>
 <CABawtvO5YxH8J3d9Ea2ya3UUCEwjPWBRJaCJJMfovgmtPPBcRQ@mail.gmail.com>
 <20131209082527.GA26950@kroah.com>
 <CABawtvOdjncv7Zo29GbdGPm-ATsPNTVZqfje2qXTYeBRX=0w9A@mail.gmail.com>
 <20131209085526.GB4125@kroah.com>
 <CABawtvPhE9enmt2NdSemVsDRp6ca38xyQSTO2mEujx0kikWtoA@mail.gmail.com>
 <20131209111747.GA6562@kroah.com>
 <CABawtvNUBwTVzFfR4UotCexARN4+As5wKEPyGmRzN7-xZ6J00w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvNUBwTVzFfR4UotCexARN4+As5wKEPyGmRzN7-xZ6J00w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 09:42:23PM +0800, Ethan Zhao wrote:
> Greg,
>     I am the man who built a Xen dom0, but couldn't see debugfs
> directory and files as expected. there is no warning or tip for me to
> enable the CONFIG_DEBUG_FS=y in .config , it cost me minutes to figure
> out what's
> the matter. and I know should check defugfs config and initialization as
> zswap_debugfs, tracer_debugfs ,rproc_debugfs did. Is it useless ? if
> it could save me just 1 minute next time ?

So you would want a "warning" showing up for every single part of the
kernel that uses debugfs for when it isn't enabled?  That doesn't make
too much sense now, does it?

If you need/want debugfs then enable it in the kernel build, it's not
that hard, right?

greg k-h
