Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbaCTOwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:52:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:34899 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933915AbaCTOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:56 -0400
Date: Thu, 20 Mar 2014 10:51:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/5] MAINTAINERS: add tools/lib/traceevent/ to perf
 subsystem
Message-ID: <20140320105154.62b4f9cc@gandalf.local.home>
In-Reply-To: <1395095198-20034-2-git-send-email-artagnon@gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
	<1395095198-20034-2-git-send-email-artagnon@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 18:26:34 -0400
Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b3fdb0f..788effd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6693,6 +6693,7 @@ F:	arch/*/kernel/*/*/perf_event*.c
>  F:	arch/*/include/asm/perf_event.h
>  F:	arch/*/kernel/perf_callchain.c
>  F:	tools/perf/
> +F:	tools/lib/traceevent/

If this goes in, I probably should get my name added as well here.
Note, I'm currently working on some clean ups to the perf system on the
kernel side.

-- Steve

>  
>  PERSONALITY HANDLING
>  M:	Christoph Hellwig <hch@infradead.org>

