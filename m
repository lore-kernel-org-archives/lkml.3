Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3A0Mln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:41:43 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58833 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A0Mlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:41:39 -0500
Date: Sun, 27 Jan 2013 13:41:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130127124133.GA3933@gmail.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> hi,
> adding sysfs attribute to specify the maximum allowed value
> for perf_event_attr::precise_ip field.
> 
> Adding functionality for simple 'precise' term to get the
> maximum allowed value for perf_event_attr::precise_ip field.
> 
> And finally adding several precise automated tests.

Ok - could we please as a next step turn on cycles:pp as the 
default in all the profiling tools (perf record, perf top), 
transparently? I.e. if the CPU supports it then use it, if not 
then don't complain, just use the highest grade profiling method 
available.

Thanks,

	Ingo
