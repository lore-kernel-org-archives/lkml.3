Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbbAVBrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:47:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:5423 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753746AbbAVBq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:46:58 -0500
Date: Wed, 21 Jan 2015 20:47:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150121204725.71933044@grimm.local.home>
In-Reply-To: <20150121230007.GA10389@kroah.com>
References: <20150121171953.823177070@goodmis.org>
	<20150121230007.GA10389@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 07:00:07 +0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> Any chance you can use kernfs as your "basis" for this filesystem
> instead of having to roll all of your own functions?  I'm slowly
> working on moving debugfs to it, and it should save a lot of code
> there, as well as fixing some "problems" we have in debugfs file
> lifetimes when things are removed from the system.

Someone else told me about doing this too. I'll take a look at it.

> 
> And given the number of mistakes in this submission, I'll wait for a
> v2 before really reading the code :)

Well, if I switch to using kernfs, I expect we should ignore this
version as well, as I would think it would make this series obsolete.

Also, if that's the case, I guess I could keep all the "tracefs" code
in kernel/tracing and not place it in the fs/ directory? Kind of like
what cgroups does.

-- Steve
