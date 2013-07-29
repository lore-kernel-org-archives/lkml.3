Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3G2Otc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab3G2Ota (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:49:30 -0400
Date: Mon, 29 Jul 2013 16:43:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] tracing: open/delete fixes
Message-ID: <20130729144336.GA10193@redhat.com>
References: <20130726172513.GA3586@redhat.com> <51F653C2.3010407@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F653C2.3010407@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Masami Hiramatsu wrote:
>
> (2013/07/27 2:25), Oleg Nesterov wrote:
> >
> > Masami, I'll appreciate your review ;)
>
> I think this is OK

Great, thanks.

> except for the bisecting issue, as I pointed in
> reply to 6/6. ;)

Perhaps, but so far the problem is not clear to me.

Anyway, if you agree with this approach we can fix the details I
missed.


Btw. I constantly forget to mention this, but it seems that with
these changes we can also remove the PITA code added by 701970b3.

Or is there another reason for fops_get() I missed?

Oleg.

