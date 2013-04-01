Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3DAVTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab3DAVTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:19:09 -0400
Date: Mon, 1 Apr 2013 23:18:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/27] perf tools: Build changes and kbuild support
Message-ID: <20130401211800.GE20670@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <5159F1D5.2040601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5159F1D5.2040601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:45:09PM -0600, David Ahern wrote:
> Hi Jiri:
> 
> On 4/1/13 1:18 PM, Jiri Olsa wrote:
> >hi,
> >sending RFC for build changes and kbuild support.
> 
> Have you seen this patch set:
> https://lkml.org/lkml/2012/8/20/59

yep, I remember checking it.. but I decided to start over
because I wanted to use kbuild build support as well

Now when I'm checking that I see you made also some source
changes to make the build separation possible. I haven't done
much on this part and some of the libraries/features/builtins
could not be disabled at the moment, because the code
is not properly separated.

> 
> It hooks into the conf commands to generate a .config file.
> Coincidentally I updated and expanded the patch series this morning
> to include dependencies and such. Latest Pconfig attached to give
> you an idea. I need to collapse a few patches and send them out
> tonight.

I'll check your repost

thanks,
jirka
