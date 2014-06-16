Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaFPNOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:14:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59778 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaFPNO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:14:29 -0400
Subject: Re: [RFC/PATCH] perf tools: Fix segfault in cumulative.callchain
 report
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20140615163404.GA1159@krava.brq.redhat.com>
References: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
	 <1402836391.1684.9.camel@leonhard>
	 <20140615163404.GA1159@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jun 2014 22:14:22 +0900
Message-ID: <1402924462.1647.26.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-15 (일), 18:34 +0200, Jiri Olsa:
> On Sun, Jun 15, 2014 at 09:46:31PM +0900, Namhyung Kim wrote:
> > Hi Jiri,
> > 
> > 2014-06-15 (일), 10:35 +0200, Jiri Olsa:
> > > heya,
> > > not completely sure this is what we want to do, but have no
> > > streght to dive into annotation code ;-)
> > 
> > Currently, cumulative entries do not accounts annotation info so
> > annotation only works for normal entries.  I'm not sure we should
> > support it or not, but anyway it also needs some updates on the
> > annotation code IMHO.
> > 
> > So I'm okay with disabling annotation on pure cumulative entries.
> 
> is that an ack? ;-)

Yep,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


