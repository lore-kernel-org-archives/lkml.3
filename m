Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3CHNRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:17:18 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33850 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3CHNRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:17:16 -0500
Date: Fri, 8 Mar 2013 14:17:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 0/2] [GIT PULL][3.9] tracing: Fix in snapshot API
Message-ID: <20130308131710.GA26790@gmail.com>
References: <20130307153442.755353831@goodmis.org>
 <51399409.4090207@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51399409.4090207@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com> wrote:

> Steven,
> 
> (03/08/2013 12:34 AM), Steven Rostedt wrote:
> >The second patch, returns success on a reset of the buffer even if
> >the buffer wasn't allocated. Returning -EINVAL is just confusing.
> 
> I realized we should update the snapshot documentation together with
> this change.
> I attached a patch to update the documentation. Could you include this
> patch?
> 
> Thanks,
> Hiraku Toyooka
> 
> 
> From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> Subject: [PATCH] tracing: update documentation of snapshot utility
> 
> Now, "snapshot" file returns success on a reset of snapshot buffer
> even if the buffer wasn't allocated, instead of returning EINVAL.
> This patch updates snapshot desctiption according to the change.
> 
> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> ---
>  Documentation/trace/ftrace.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 53d6a3c..a372304 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -1873,7 +1873,7 @@ feature:
> 
>  	status\input  |     0      |     1      |    else    |
>  	--------------+------------+------------+------------+
> -	not allocated |(do nothing)| alloc+swap |   EINVAL   |
> +	not allocated |(do nothing)| alloc+swap |(do nothing)|
>  	--------------+------------+------------+------------+
>  	allocated     |    free    |    swap    |   clear    |
>  	--------------+------------+------------+------------+

I pulled all the updates - thanks guys!

	Ingo
