Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3KGKHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:07:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3KGKHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:07:00 -0500
Date: Thu, 7 Nov 2013 11:06:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 0/2] perf record: mmap output file - v3
Message-ID: <20131107100619.GB1251@krava.brq.redhat.com>
References: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
 <527A81B8.7040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A81B8.7040505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:51:52AM -0700, David Ahern wrote:
> On 11/4/13, 11:31 AM, Jiri Olsa wrote:
> >hi,
> >after discussion with David, sending his change
> >updated into the new data file object.
> >
> >David's original post:
> >   http://marc.info/?l=linux-kernel&m=138180575328977&w=2
> >
> >Here's the change:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   perf/mmap1
> >
> 
> Not having any luck with these patches. Basic use case:
> 
> perf trace record -a -- sleep 5
> perf trace --summary
> 
> With your patches I get a parse error. With my latest versions
> everything works clean.

hum, 
perf trace --summary seems stuck in a loop, but that's no
different from current acme's perf/core.

Anyway I'll postpone the change till your v3 goes in
and go from there.

jirka
