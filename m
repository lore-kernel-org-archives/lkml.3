Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3IJVJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:09:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58907 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3IJVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:09:30 -0400
Date: Tue, 10 Sep 2013 22:09:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lock held returning to user space (i_mutex_dir_key)
Message-ID: <20130910210923.GA13318@ZenIV.linux.org.uk>
References: <20130910210237.GA15371@redhat.com>
 <20130910210425.GB15371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910210425.GB15371@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:04:25PM -0400, Dave Jones wrote:
> On Tue, Sep 10, 2013 at 05:02:37PM -0400, Dave Jones wrote:
>  > ================================================
>  > [ BUG: lock held when returning to user space! ]
>  > 3.11.0+ #64 Not tainted
>  > ------------------------------------------------
>  > trinity-child2/8333 is leaving the kernel with locks still held!
>  > 1 lock held by trinity-child2/8333:
>  >  #0:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<ffffffff811c7fce>] mountpoint_last+0x4e/0x1a0
> 
> This perhaps ?

Applied
