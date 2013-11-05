Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3KEOzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:55:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab3KEOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:55:44 -0500
Date: Tue, 5 Nov 2013 12:55:24 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/3] perf tools: Factor sysfs code into generic fs object
Message-ID: <20131105145524.GB5539@infradead.org>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
 <1383563173-17466-2-git-send-email-jolsa@redhat.com>
 <20131105124814.GA5539@infradead.org>
 <20131105130729.GD1071@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105130729.GD1071@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 05, 2013 at 02:07:29PM +0100, Jiri Olsa escreveu:
> On Tue, Nov 05, 2013 at 10:48:14AM -0200, Arnaldo Carvalho de Melo wrote:
> > I know you haven't written this code, is just generalizing, but I got
> > confused so had to comment on it :-\
> 
> yep ;-) perhaps some init code could do that

At some point I want to have an init system similar to the kernel, i.e.
mark something as needing to be initialized with something like __init
and some linker magic (stolen from the kernel) would do it, think about
gtk, tui, symbol lib, lotsa init stuff, with some ordering
constraints...
 
> > Perhaps since you're just making it useful for more filesystems just
> > please address the 'perf_fs' naming suggestions and we can deal with
> > these other issues later?
> 
> ok, I have already changes for the 3/3 change,
> I'll send it together

Thanks!

- Arnaldo
