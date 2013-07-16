Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3GPLwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:52:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab3GPLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:52:08 -0400
Message-ID: <51E533BA.3060103@zytor.com>
Date: Tue, 16 Jul 2013 04:51:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/5] perf: fix broken union in perf_event_mmap_page
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com> <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <20130628152224.GG6626@twins.programming.kicks-ass.net>
In-Reply-To: <20130628152224.GG6626@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 08:22 AM, Peter Zijlstra wrote:
> 
> Ick, it did that!? and here I thought there was a difference between:
> 
>   int foo:1,
>       bar:1;
> 
> and
> 
>   int foo:1;
>   int bar:1;
> 
> That made all the difference in this particular case. I guess I should
> go read the language spec more carefully next time.
> 

There is absolutely no difference there...

	-hpa

