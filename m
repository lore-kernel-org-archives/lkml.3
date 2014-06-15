Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaFOQeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 12:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaFOQeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 12:34:19 -0400
Date: Sun, 15 Jun 2014 18:34:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/PATCH] perf tools: Fix segfault in cumulative.callchain
 report
Message-ID: <20140615163404.GA1159@krava.brq.redhat.com>
References: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
 <1402836391.1684.9.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402836391.1684.9.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 09:46:31PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2014-06-15 (일), 10:35 +0200, Jiri Olsa:
> > heya,
> > not completely sure this is what we want to do, but have no
> > streght to dive into annotation code ;-)
> 
> Currently, cumulative entries do not accounts annotation info so
> annotation only works for normal entries.  I'm not sure we should
> support it or not, but anyway it also needs some updates on the
> annotation code IMHO.
> 
> So I'm okay with disabling annotation on pure cumulative entries.

is that an ack? ;-)

thanks,
jirka
