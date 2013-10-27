Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3J0HNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:13:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39273 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3J0HN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:13:28 -0400
Date: Sun, 27 Oct 2013 00:13:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Henrik Austad <henrik@austad.us>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: add missing files to timers/00-INDEX
Message-ID: <20131027071323.GF4118@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1382821452-24524-1-git-send-email-henrik@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382821452-24524-1-git-send-email-henrik@austad.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102707-8236-0000-0000-000003217A71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 11:04:12PM +0200, Henrik Austad wrote:
> From: Henrik Austad <haustad@cisco.com>
> 
> - timers-howto was added by commit 0fcb8081 (Documentation: Add
>   timers/timers-howto.txt)
> - NO_HZ was added by commit 0c87f9b5 (nohz_full: Add documentation.)
> 
> Cc: Patrick Pannuto <ppannuto@codeaurora.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Jiri Kosina <trivial@kernel.org>
> Signed-off-by: Henrik Austad <haustad@cisco.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  Documentation/timers/00-INDEX |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
> index a9248da..ef2ccbf 100644
> --- a/Documentation/timers/00-INDEX
> +++ b/Documentation/timers/00-INDEX
> @@ -8,5 +8,9 @@ hpet_example.c
>  	- sample hpet timer test program
>  hrtimers.txt
>  	- subsystem for high-resolution kernel timers
> +NO_HZ.txt
> +	- Summary of the different methods for the scheduler clock-interrupts management.
> +timers-howto.txt
> +	- how to insert delays in the kernel the right (tm) way.
>  timer_stats.txt
>  	- timer usage statistics
> -- 
> 1.7.2.5
> 

