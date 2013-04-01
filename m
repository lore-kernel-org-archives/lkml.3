Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab3DAVIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab3DAVH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:07:59 -0400
Date: Mon, 1 Apr 2013 23:05:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 27/27] perf tools: Add kbuild support into Makefile.kbuild
Message-ID: <20130401210550.GA20670@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <1364843930-17974-28-git-send-email-jolsa@redhat.com>
 <20130401200342.GD5744@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401200342.GD5744@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:03:42PM +0200, Sam Ravnborg wrote:
> On Mon, Apr 01, 2013 at 09:18:50PM +0200, Jiri Olsa wrote:
> > Adding kbuild support into Makefile.kbuild. The 'legacy'
> > Makefile still stays untouched as it was.
> 
> When readign the Kbuild file I get confused.
> the obj-y syntax is used for kernel built-in stuff,
> and obj-m for modules.
> I had expected either a perf specific syntax or something like the
> syntax used for host programs.

While building kernel you need to have separate flags
for internal objects and for host programs.

First, I thought I need to separate it as you say, but
perf build is separated from kernel built process, so
AFAICS we can use obj-y with no harm in perf.

It's quite possible I missed something and kbuild folks
prove me wrong ;-)

The Makefile.kbuild defines flags to be used for obj-y.

jirka
