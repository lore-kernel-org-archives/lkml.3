Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaIZLAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:00:12 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37889 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaIZLAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:00:09 -0400
Message-ID: <1411729190.3852.21.camel@hornet>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
From: Pawel Moll <pawel.moll@arm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 26 Sep 2014 11:59:50 +0100
In-Reply-To: <87y4t6j40p.fsf@sejong.aot.lge.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	 <87oau5k0u9.fsf@sejong.aot.lge.com> <20140924072017.GC990@gmail.com>
	 <87y4t6j40p.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 07:21 +0100, Namhyung Kim wrote:
> It looks like what trace-marker in ftrace does..  We might connect
> output of the trace marker into a perf event somehow.

I can probably trace_marker's write handler do the same as the new
prctl() would do. But this means that we really want the pre-defined
"zero terminated string" type (0). Otherwise, what type would be
assigned to a record originating from it?

Pawel

