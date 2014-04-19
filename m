Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaDSP20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 11:28:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55908 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059AbaDSP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 11:28:23 -0400
Date: Sat, 19 Apr 2014 11:28:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Lin Yongting <linyongting@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linyongting@huawei.com
Subject: Re: [PATCH] tracing: Correct braces usage in if-else statement
Message-ID: <20140419112821.6ee5b104@gandalf.local.home>
In-Reply-To: <1397915903-21326-1-git-send-email-linyongting@gmail.com>
References: <1397915903-21326-1-git-send-email-linyongting@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2014 21:58:23 +0800
Lin Yongting <linyongting@gmail.com> wrote:

> There are some incorrect braces usages in kernerl/trace/trace.c, including:
> 1. Missing braces in 'if' or 'else' branch.
> 2. Unnecessary braces in 'if' statement.
> 
> Fix them according to kernel CodeStyle.

I understand that this is part of the CodeStyle, but I'm not accepting
this patch. It causes more pain than it is worth, as it makes it more
difficult to see git history because of "clean up" changes that get in
the way. I also honestly don't think this is much of a clean up.

Sorry,

-- Steve


> 
> Signed-off-by: Lin Yongting <linyongting@gmail.com>
> ---
>  kernel/trace/trace.c |   39 +++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
