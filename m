Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3A1R7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:59:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab3A1R7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:59:53 -0500
Date: Mon, 28 Jan 2013 14:59:38 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v6 2/2] perf stat: add interval printing
Message-ID: <20130128175938.GA15351@infradead.org>
References: <1358860732-4435-1-git-send-email-eranian@google.com>
 <1358860732-4435-3-git-send-email-eranian@google.com>
 <20130125025247.GA16249@infradead.org>
 <CABPqkBT-JuR=3q4X2o7Et9idd3T5Ut_GSnhpQKbqfr5SC4eDWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT-JuR=3q4X2o7Et9idd3T5Ut_GSnhpQKbqfr5SC4eDWA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 25, 2013 at 04:21:11PM +0100, Stephane Eranian escreveu:
> On Fri, Jan 25, 2013 at 3:52 AM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Tue, Jan 22, 2013 at 02:18:52PM +0100, Stephane Eranian escreveu:
> >> This patch adds a new printing mode for perf stat.
> >> It allows internval printing. That means perf stat
> >> can now print event deltas at regular time interval.
> >> This is useful to detect phases in programs.
> >
> > This patch is not applying to my perf/core branch, does it depend on
> > some other outstanding patchset from you?
> >
> > Tomorrow probably all I had in this area will be in Ingo's tree, but
> > can you please take a look at my perf/core branch at:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
> >
> My patches are always relative to:
> git://git.kernel.org/pub/scm/linux/kernel/git/tip.tip.git
> 
> Do you still need to rebase against your tree?

Well, userspace code normally is developed on my tree and eventually
goes to the one you mentioned. If you make sure that now, that both are
synched after some weeks, then probably it'll work with my tree.

- Arnaldo
