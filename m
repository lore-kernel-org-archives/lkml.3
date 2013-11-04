Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3KDOg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:36:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab3KDOg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:36:58 -0500
Date: Mon, 4 Nov 2013 15:38:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
	ring buffer
Message-ID: <20131104143813.GB4440@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <1383029621-7384-11-git-send-email-namhyung@kernel.org> <20131101150910.GA18278@redhat.com> <20131101152232.GA2703@redhat.com> <20131103202037.GA2785@redhat.com> <87txfs37ta.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txfs37ta.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, Namhyung Kim wrote:
>
> On Sun, 3 Nov 2013 21:20:37 +0100, Oleg Nesterov wrote:
> >
> > But. Perhaps it makes sense to at least add a couple of trivial
> > helpers in 10/13? Something like arg_buf_get/put/init, just to
> > simplify the potential changes.
>
> Good idea.  How about something like below?

Thanks, I agree with any implementation ;)

> static DEFINE_MUTEX(uprobe_buffer_mutex);

but see my previous email, afaics we don't need it.

Oleg.

