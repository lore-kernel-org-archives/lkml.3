Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaIZL0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:26:47 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37907 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaIZL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:26:46 -0400
Message-ID: <1411730797.3852.23.camel@hornet>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 26 Sep 2014 12:26:37 +0100
In-Reply-To: <20140926112312.GB9870@gmail.com>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
	 <1411491764.3922.46.camel@hornet> <20140924074942.GB3797@gmail.com>
	 <1411665649.4768.84.camel@hornet> <20140925183342.GB6854@gmail.com>
	 <1411728487.3852.9.camel@hornet> <20140926112312.GB9870@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 12:23 +0100, Ingo Molnar wrote:
> > As in: allows *all* tasks to inject the data? Are you sure we 
> > don't want more fine-grained control, in particular per task?
> 
> Yeah. If the profiler allows it, then any task that is being 
> traced can inject data.

The "that is being traced" fragment was the key here. I missed the fact
that perf trace already takes a list of pids, so we're not talking about
all tasks in the system. That should work.

Paweł

