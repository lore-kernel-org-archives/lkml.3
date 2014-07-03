Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbaGCXYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:24:09 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46189 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbaGCXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:24:07 -0400
Date: Thu, 3 Jul 2014 16:24:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/16] MAINTAINERS: Update rcu torture patterns
Message-ID: <20140703232401.GJ4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1404425176.git.joe@perches.com>
 <0b75a7766bc8b511b0397a7bf8b76643d0a0680c.1404425177.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b75a7766bc8b511b0397a7bf8b76643d0a0680c.1404425177.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070323-7164-0000-0000-000002E40331
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 03:08:00PM -0700, Joe Perches wrote:
> commit 51b1130eb582 ("rcutorture: Abstract rcu_torture_random()")
> moved the file, update the patterns
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index de0d181..473c00c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7374,7 +7374,7 @@ L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>  F:	Documentation/RCU/torture.txt
> -F:	kernel/rcu/torture.c
> +F:	kernel/rcu/rcutorture.c
> 
>  RCUTORTURE TEST FRAMEWORK
>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> @@ -7418,7 +7418,7 @@ X:	Documentation/RCU/torture.txt
>  F:	include/linux/rcu*
>  X:	include/linux/srcu.h
>  F:	kernel/rcu/
> -X:	kernel/rcu/torture.c
> +X:	kernel/torture.c
> 
>  REAL TIME CLOCK (RTC) SUBSYSTEM
>  M:	Alessandro Zummo <a.zummo@towertech.it>
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 

