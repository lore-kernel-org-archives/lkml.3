Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaE0HiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:38:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaE0HiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:38:22 -0400
Date: Tue, 27 May 2014 09:38:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/14] perf tools: Add dso__data_* interface descriptons
Message-ID: <20140527073812.GB12920@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <1400174615-2121-10-git-send-email-jolsa@kernel.org>
 <87ppj0hvx3.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppj0hvx3.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:06:48AM +0900, Namhyung Kim wrote:
> On Thu, 15 May 2014 19:23:30 +0200, Jiri Olsa wrote:
> 
> [SNIP]
> > +/**
> > + * dso__data_read_addr - Read data from dso address
> > + * @dso: dso object
> > + * @machine: machine object
> > + * @offset: file offset
> 
> s/offset/addr/

oops.. copy/paste stuff ;-\

thanks,
jirka
