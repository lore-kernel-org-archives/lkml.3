Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaIZLYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:24:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38806 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaIZLY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:24:29 -0400
Date: Fri, 26 Sep 2014 13:24:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Message-ID: <20140926112424.GC9870@gmail.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
 <1411491787-25938-3-git-send-email-pawel.moll@arm.com>
 <87oau5k0u9.fsf@sejong.aot.lge.com>
 <20140924072017.GC990@gmail.com>
 <87y4t6j40p.fsf@sejong.aot.lge.com>
 <1411729190.3852.21.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411729190.3852.21.camel@hornet>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pawel Moll <pawel.moll@arm.com> wrote:

> On Fri, 2014-09-26 at 07:21 +0100, Namhyung Kim wrote:
>
> > It looks like what trace-marker in ftrace does..  We might 
> > connect output of the trace marker into a perf event somehow.
> 
> I can probably trace_marker's write handler do the same as the 
> new prctl() would do. [...]

Please keep this new facility separate, so that !ftrace kernels 
that have perf events enabled still have this facility, etc.

Thanks,

	Ingo
