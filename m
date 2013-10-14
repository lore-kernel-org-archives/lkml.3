Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3JNIDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab3JNIDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:03:31 -0400
Date: Mon, 14 Oct 2013 10:03:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf make: Move DEBUG initialization into Makefile.perf
Message-ID: <20131014080304.GB1590@krava.redhat.com>
References: <1381699329-6418-1-git-send-email-jolsa@redhat.com>
 <20131014071611.GA16533@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014071611.GA16533@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:16:11AM +0200, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > Adding new top level Makefile invalidated the
> > DEBUG variable check for "command line" origin.
> > 
> > Moving this check into Makefile.perf.
> 
> This ought to be fixed in my latest tip:tmp.perf branch. The fix commit in 
> particular is:
> 
>   91a7b6db20ae tools/perf/build: Pass through DEBUG parameter
> 
> I'm waiting for Arnaldo to send an updated perf/core and then I will 
> double check whether any of the fixes is missing.

ook, thanks

jirka
