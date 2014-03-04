Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaCDXpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:45:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaCDXpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:45:20 -0500
Message-ID: <5316655A.9060102@zytor.com>
Date: Tue, 04 Mar 2014 15:44:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Closing on the CR2 leak bug
References: <531654D8.5040409@zytor.com> <20140304184112.0a3fe811@gandalf.local.home>
In-Reply-To: <20140304184112.0a3fe811@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 03:41 PM, Steven Rostedt wrote:
> 
> The only other issue is if perf traces from function context and traces
> the trace_do_page_fault() call. But other than that, sure, take Jiri's
> patch.
> 

Is there a known codepath on which that can happen?

	-hpa

