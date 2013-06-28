Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3F1P15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:27:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53790 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3F1P14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:27:56 -0400
Date: Fri, 28 Jun 2013 17:27:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf: add two new features
Message-ID: <20130628152745.GH6626@twins.programming.kicks-ass.net>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 04:22:16PM +0300, Adrian Hunter wrote:
> Hi
> 
> Please consider these two new perf features:
>       x86: add ability to calculate TSC from perf sample timestamps
>       perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE

Please explain to us why you'd like to do this..
