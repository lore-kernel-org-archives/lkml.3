Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaDGOH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:07:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGOH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:07:27 -0400
Date: Mon, 7 Apr 2014 07:09:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ken Cox <jkc@redhat.com>, linux-kernel@vger.kernel.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        Jet Chen <jet.chen@intel.com>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Message-ID: <20140407140958.GA7346@kroah.com>
References: <20140407111725.GC25152@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407111725.GC25152@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 07:17:25PM +0800, Fengguang Wu wrote:
> Hi Ken,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> commit 12e364b9f08aa335dc7716ce74113e834c993765
> Author:     Ken Cox <jkc@redhat.com>
> AuthorDate: Tue Mar 4 07:58:07 2014 -0600
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Tue Mar 4 16:58:21 2014 -0800
> 
>     staging: visorchipset driver to provide registration and other services

I think Sasha has already sent a fix to resolve this issue that I'll be
sending to Linus in a day or so.

Ken, is Sasha's patch going to resolve this issue as well?  It looks
like people haven't tested what happens when the module is loaded
without the hardware present in the system :(

thanks,

greg k-h
