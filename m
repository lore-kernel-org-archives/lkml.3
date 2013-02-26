Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3BZUG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:06:27 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41105 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab3BZUG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:06:26 -0500
Date: Tue, 26 Feb 2013 12:03:43 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        robert.richter@amd.com, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, benh@kernel.crashing.org
Subject: Re: [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event
 format
Message-ID: <20130226200343.GA21543@us.ibm.com>
References: <20130123062201.GA13720@us.ibm.com>
 <20130123062613.GF13720@us.ibm.com>
 <20130226052646.GB21553@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226052646.GB21553@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022620-5806-0000-0000-0000201A7355
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| On Tue, Jan 22, 2013 at 10:26:13PM -0800, Sukadev Bhattiprolu wrote:
| > 
| > [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event format
| > 
| > Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
| > which describes the format of a POWER cpu.
| 
| Did this patch go upstream? I don't see it.

Hmm, patches 1..4,6 are in linux-tip and Arnaldo's trees but patch 5 is
in neither.

| 
| If not, please don't merge it.
| 
| > The format of the event is the same for all POWER cpus at least in
| > (Power6, Power7), so bulk of this change is common in the code common
| > to POWER cpus.
| 
| No. The event format is different on most POWER cpus, in particular it
| is different on Power6 and Power7, and will be different again on
| Power8.

Sigh.  The port of this patchset to Power6 has not started yet.

But this patchset does work on Power7 correct ?

If so, and we figure out what happened to patch 5, can we add a patch to
to move the format code to power7-pmu.c ?

Sukadev

