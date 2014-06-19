Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbaFSTlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:41:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:21829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbaFSTlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:41:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="560343626"
Message-ID: <1403207332.15603.52.camel@rage>
Subject: Re: [PATCH 9/9] perf bench: futex: Support operations for shared
 futexes
From: Darren Hart <darren@dvhart.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, jolsa@kernel.org,
        mitake@dcl.info.waseda.ac.jp, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 12:48:52 -0700
In-Reply-To: <20140619170507.GA31524@kernel.org>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
	 <1402942467-10671-10-git-send-email-davidlohr@hp.com>
	 <20140619164124.GH20252@kernel.org>
	 <1403196229.29394.10.camel@buesod1.americas.hpqcorp.net>
	 <20140619170507.GA31524@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 14:05 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 19, 2014 at 09:43:49AM -0700, Davidlohr Bueso escreveu:
> > On Thu, 2014-06-19 at 13:41 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Jun 16, 2014 at 11:14:27AM -0700, Davidlohr Bueso escreveu:
> > > > Unlike futex-hash, requeuing and wakeup benchmarks do not support
> > > > shared futexes, limiting the usefulness of the programs. Correct
> > > > this, and allow using the local -S parameter. The default remains
> > > > using private futexes.
> > > 
> > > Also isn't this benchmark related to something Darren did? Just checking
> > > why he isn't in the CC list, Darren, does this all sound fine to you?
> > 
> > Darren is well aware of these benchmarks, and we've discussed the topic
> > in the past. This change doesn't conflict with what he maintains in the
> > futextest suite.
> 
> Ok, thanks, just checking :-)

Right. The plan, for the record, is to augment functional tests in
futextest and move all performance related tests to perf. Davidlohr's
tests are independent from those in futextest. I haven't done an
exhaustive comparison to see if there is overlap, but since he got to
perf first, we'll determine which futextest/performance tests add value
and add tose, and deep six the rest.

The functional tests may then be moved to linux/tools and futextest will
then be obsolete.

-- 
Darren Hart
Intel Open Source Technology Center


