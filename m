Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaGRG5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaGRG5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:57:24 -0400
Date: Fri, 18 Jul 2014 08:57:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 4/5] perf tools: Add --debug optionto set debug variable
Message-ID: <20140718065709.GA12373@krava.redhat.com>
References: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
 <1405374411-29012-5-git-send-email-jolsa@kernel.org>
 <87wqbc1juy.fsf@sejong.aot.lge.com>
 <20140717105500.GG516@krava.redhat.com>
 <87ha2fl0jw.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha2fl0jw.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:04:51PM +0900, Namhyung Kim wrote:

SNIP

> >  #include "util/quote.h"
> >  #include "util/run-command.h"
> >  #include "util/parse-events.h"
> > +#include "util/debug.h"
> >  #include <api/fs/debugfs.h>
> >  #include <pthread.h>
> >  
> >  const char perf_usage_string[] =
> > -	"perf [--version] [--help] COMMAND [ARGS]";
> > +	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";
> 
> You missed to update here.. ;-)

ouch, I'll fix that in following patchset

thanks,
jirka
