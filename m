Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaAMKsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:48:45 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:54247 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaAMKsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:48:43 -0500
Date: Mon, 13 Jan 2014 12:48:39 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: design.txt: remove mention of
 set_perf_event_pending
Message-ID: <20140113104839.GN4944@tarshish>
References: <bd81da79fb3cfca28d7e990566c8794ec14328c7.1385647452.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd81da79fb3cfca28d7e990566c8794ec14328c7.1385647452.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi perf maintainers,

Ping?

On Thu, Nov 28, 2013 at 04:04:12PM +0200, Baruch Siach wrote:
> set_perf_event_pending() was removed in e360adbe (irq_work: Add generic hardirq
> context callbacks)
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  tools/perf/design.txt | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/perf/design.txt b/tools/perf/design.txt
> index 67e5d0c..63a0e6f 100644
> --- a/tools/perf/design.txt
> +++ b/tools/perf/design.txt
> @@ -454,7 +454,6 @@ So to start with, in order to add HAVE_PERF_EVENTS to your Kconfig, you
>  will need at least this:
>  	- asm/perf_event.h - a basic stub will suffice at first
>  	- support for atomic64 types (and associated helper functions)
> -	- set_perf_event_pending() implemented
>  
>  If your architecture does have hardware capabilities, you can override the
>  weak stub hw_perf_event_init() to register hardware counters.

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
