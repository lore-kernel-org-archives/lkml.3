Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaFORyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaFORyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:54:36 -0400
Date: Sun, 15 Jun 2014 19:54:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 14/17] perf tools: Add report.queue-size config file
 option
Message-ID: <20140615175425.GE1159@krava.brq.redhat.com>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
 <1402610913-19059-15-git-send-email-jolsa@kernel.org>
 <1402661338.2178.22.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402661338.2178.22.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:08:58PM +0900, Namhyung Kim wrote:
> 2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> > Adding report.queue-size config file option to setup
> > the maximum allocation size for session's struct
> > ordered_events_queue object.
> 
> Only a config option without a command line switch?

Yea.. it did not seem necessary to me to add another
one to the report heap for this.

Also considering the default size I added (100MB) and quite low
level nature of this.. but I dont have strong opinion on this..

thoughts?

thanks,
jirka
