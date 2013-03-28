Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3C1PAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab3C1PAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:00:45 -0400
Date: Thu, 28 Mar 2013 12:00:18 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core support
Message-ID: <20130328150018.GA13795@infradead.org>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <1359040242-8269-12-git-send-email-eranian@google.com>
 <20130327141425.GC1092@krava.brq.redhat.com>
 <1364394014.5053.76.camel@laptop>
 <20130327143437.GE1092@krava.brq.redhat.com>
 <CABPqkBSSBdzGJtJ6HLFCM_Hhnwv1ASZ=JCX+zpWcM5X3KwZk6w@mail.gmail.com>
 <20130327165644.GB14744@infradead.org>
 <CABPqkBQESorC6U6kZOjntdgsnwTkT4GiT669mVHw6Wuf_JqDbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQESorC6U6kZOjntdgsnwTkT4GiT669mVHw6Wuf_JqDbQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 28, 2013 at 03:24:30PM +0100, Stephane Eranian escreveu:
> On Wed, Mar 27, 2013 at 5:56 PM, Arnaldo Carvalho de Melo
> > Stephane, if you could give it a try again to see that the fixups I did
> > (documented in the commit logs, just before my Signed-off-by) are ok,
> > that would be good.

> I tried on a few examples on both NHM (only loads, no TLB) and SNB
> and got the right answers for my tests, including data symbol resolution.

> What we discussed with Jiri yesterday can be added later on.

> Thanks for the integration work. Looks good to me.

Humm, I just tried it with a simple:

perf mem -t load rec

And got an OOPS, trying again, and this machine was suspended, perhaps
perf/core doesn't have that PEBS fix, will check.

- Arnaldo
