Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFMN7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:59:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22723 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751452AbaFMN7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:59:37 -0400
Date: Fri, 13 Jun 2014 09:59:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 4/4] tools lib traceevent: Fix and cleanup
 kvm_nested_vmexit tracepoints
Message-ID: <20140613095934.7274672b@gandalf.local.home>
In-Reply-To: <1402653337.2178.6.camel@leonhard>
References: <20140613021002.444608350@goodmis.org>
	<20140613021157.484318137@goodmis.org>
	<1402653337.2178.6.camel@leonhard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014 18:55:37 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> >  {
> > -	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
> > +	pevent_print_num_field(s, "rip %lx ", event, "rip", record, 1);
> 
> s/%lx/%llx/

I'll make this as a separate fix to keep the original patch as is.

> 
> Otherwise this series and previous two cleanup patches look good to me.
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> 

Thanks!

-- Steve

