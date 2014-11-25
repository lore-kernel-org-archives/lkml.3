Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKYOzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:55:17 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42389 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaKYOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:55:12 -0500
Date: Tue, 25 Nov 2014 14:55:09 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v4 00/11] perf: Intel Cache QoS Monitoring support
Message-ID: <20141125145509.GB3331@console-pimps.org>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov, at 09:15:01PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> This patch series adds a new PMU driver for the Intel Cache Monitoring
> hardware feature available in Intel Xeon processors, which allows
> monitoring of LLC occupancy on a task, group or system-wide basis.
> 
> The first few patches modify tools/perf to handle per-package counters,
> which necessitates discarding some values when doing per-cpu reads to
> avoid getting duplicate data. The rest add support for the new PMU code.
> 
> I've left a notoriously funky bit of code near the end of the series,
> the RMID rotation code, in an attempt to simplify things. Doing the
> rotation provides the ability to multiplex the RMIDs and basically
> overcome the hardware limitation, but the rest of the patches work fine
> without it. But there are a number of scenarios where being able to
> monitor more tasks than RMIDs is extremely useful.
> 
> The series is based on tip/perf/core.

Any feedback on this series?

Stephane, the original thread is here, 

  https://lkml.kernel.org/r/1415999712-5850-1-git-send-email-matt@console-pimps.org

-- 
Matt Fleming, Intel Open Source Technology Center
