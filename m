Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaE0HkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaE0HkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:40:04 -0400
Date: Tue, 27 May 2014 09:39:53 +0200
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
Subject: Re: [PATCH 10/14] perf tests: Spawn child for each test
Message-ID: <20140527073953.GC12920@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <1400174615-2121-11-git-send-email-jolsa@kernel.org>
 <87lhtohvue.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhtohvue.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:08:25AM +0900, Namhyung Kim wrote:
> On Thu, 15 May 2014 19:23:31 +0200, Jiri Olsa wrote:
> > In upcoming tests we will setup process limits, which
> > might affect other tests. Spawning child for each test
> > to prevent this.
> 
> But you can restore original limits after the test using soft limits?
> But I think it's better to run the tests in a child anyway. :)

right.. I also recalled that Ingo recommended this before,
I'll queue this one separately..

thanks,
jirka

> 
> Thanks,
> Namhyung
