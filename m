Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab3GRPC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:02:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab3GRPC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:02:26 -0400
Date: Thu, 18 Jul 2013 16:55:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC PATCH 3/4] tracing: Kill
	tracing_open/release_generic_file
Message-ID: <20130718145544.GA6588@redhat.com>
References: <20130716185726.GA21200@redhat.com> <1374004295.6458.59.camel@gandalf.local.home> <20130717191917.GA14137@redhat.com> <51E7C9E3.1070506@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7C9E3.1070506@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Masami Hiramatsu wrote:
>
> (2013/07/18 4:19), Oleg Nesterov wrote:
> > Once again, this is just RFC to know your and Masami's opinion. If
> > you think this can work, I'll try to resend this series with the
> > additional bits to cover instance_delete() too. _Afaics_ this needs
> > some temporary uglifications "in between".
>
> I think your proposal goes a good direction, but it also requires
> completeness, because, as I pointed, we have to take care of all
> operations are correctly checked except for open/close.
>
> So, I agree with Steven, I'd like to see a complete patchset.

OK. In fact _I think_ it is almost complete, just this series should
remove tracing_open_generic_file() in the last patch, after we change
__trace_remove_event_dirs() to use invalidate_event_files().

I'll try to finish this series and resend, probably tomorrow.

Oleg.

