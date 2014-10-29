Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbaJ2WE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:04:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbaJ2WEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:04:25 -0400
Date: Wed, 29 Oct 2014 15:03:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [RFA][PATCH 8/8] debugfs: Have debugfs_print_regs32() return void
Message-ID: <20141029220315.GA7276@kroah.com>
References: <20141029215602.535533597@goodmis.org>
 <20141029220108.467786659@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029220108.467786659@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:56:10PM -0400, Steven Rostedt wrote:
> From: Joe Perches <joe@perches.com>
> 
> [ REQUEST FOR ACKS ]
> 
> The seq_printf() will soon just return void, and seq_has_overflowed()
> should be used instead to see if the seq can no longer accept input.
> 
> As the return value of debugfs_print_regs32() has no users and
> the seq_file descriptor should be checked with seq_has_overflowed()
> instead of return values of functions, it is better to just have
> debugfs_print_regs32() also return void.
> 
> Link: http://lkml.kernel.org/p/2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> [ original change only updated seq_printf() return, added return of
>   void to debugfs_print_regs32() as well ]
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
