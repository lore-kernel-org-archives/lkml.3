Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3H3Lib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:38:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43830 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab3H3Lia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:38:30 -0400
Date: Fri, 30 Aug 2013 13:38:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: put proper symbol in the unstable schedclock
 warning
Message-ID: <20130830113826.GD7806@somewhere>
References: <alpine.LNX.2.00.1308051420290.17512@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1308051420290.17512@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 02:21:13PM +0200, Jiri Kosina wrote:
> Since e12d0271 ("nohz: Warn if the machine can not perform nohz_full") 
> Kernel triggers a WARN() in case sched clock is marked as unstable.
> 
> Make it output a proper Kconfig symbol (NO_HZ_FULL) when informing user 
> about this.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

I'm queuing this, thanks!

> ---
>  kernel/time/tick-sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index e77edc9..e0030ed 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -182,7 +182,7 @@ static bool can_stop_full_tick(void)
>  		 * Don't allow the user to think they can get
>  		 * full NO_HZ with this machine.
>  		 */
> -		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
> +		WARN_ONCE(1, "NO_HZ_FULL will not work with unstable sched clock");
>  		return false;
>  	}
>  #endif
> 
> -- 
> Jiri Kosina
> SUSE Labs
