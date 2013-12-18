Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3LRUeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:34:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab3LRUdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:33:44 -0500
Date: Wed, 18 Dec 2013 21:34:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to
	kprobes
Message-ID: <20131218203423.GA11344@redhat.com>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org> <1387168336-13213-11-git-send-email-namhyung@kernel.org> <52AEB87D.6020507@hitachi.com> <87fvptgpe0.fsf@sejong.aot.lge.com> <8738lsgwm2.fsf@sejong.aot.lge.com> <20131218152553.04c04042@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218152553.04c04042@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Steven Rostedt wrote:
>
> On Tue, 17 Dec 2013 09:16:37 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
> > Hi Steve,
> >
> > Would you please review this and consider merging it?  It seems there's
> > no more remaining issue and we want to make a progress on it. :)
> >
> > Oleg, Srikar, it'd be great if you could confirm it though.
> >
>
> I'd feel better if we got some feedback from Oleg and Srikar too.

Sorry, didn't have the time to review.

I'll try very much to do this tomorrow. But I do not expect I will find
something interesting, at first glance this version addresses all concerns
I had.

Oleg.

