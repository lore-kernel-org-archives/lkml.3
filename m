Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaCBQm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 11:42:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaCBQm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 11:42:27 -0500
Date: Sun, 2 Mar 2014 17:42:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3] perf: Disable user space dumps for function trace
 event
Message-ID: <20140302164206.GA14982@krava.brq.redhat.com>
References: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 04:56:37PM +0100, Jiri Olsa wrote:
> hi,
> recent issues with user space callchains processing within
> page fault handler tracing showed as Peter said 'there's
> just too much fail surface'.
> 
> Related list discussions:
>   http://marc.info/?t=139302086500001&r=1&w=2
>   http://marc.info/?t=139301437300003&r=1&w=2
> 
> Disabling user space callchain and stack dump for
> function trace event. Plus updating the perf tool
> to keep up with those changes.
> 

Reachable here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/function_trace_fixies_1

jirka
