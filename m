Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaE0Hvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaE0Hvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:51:45 -0400
Date: Tue, 27 May 2014 09:51:30 +0200
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
Subject: Re: [PATCH 12/14] perf tests: Add test interface for dso data fd
 limit
Message-ID: <20140527075130.GD12920@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <1400174615-2121-13-git-send-email-jolsa@kernel.org>
 <87ha4chvqn.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha4chvqn.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:10:40AM +0900, Namhyung Kim wrote:
> On Thu, 15 May 2014 19:23:33 +0200, Jiri Olsa wrote:
> > Adding a way to setup test dso limit by global variable
> > test_dso_data__fd_limit. It'll be used in the dso data
> > cache tests.
> 
> Why is this needed?  Why not justing setting RLIMIT_NOFILE in the test
> cases?

well, I wanted to avoid to customizing the test to the current
open files count state.. the way with artifical limit is easier
and more clean IMO ;-)

I'll see if I can make the setup without this one

thanks,
jirka
