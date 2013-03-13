Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3CMAPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:15:48 -0400
Received: from ozlabs.org ([203.10.76.45]:37533 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3CMAPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:15:45 -0400
Date: Wed, 13 Mar 2013 11:15:43 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        robert.richter@amd.com, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, benh@kernel.crashing.org
Subject: Re: [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event
 format
Message-ID: <20130313001542.GA5058@concordia>
References: <20130123062201.GA13720@us.ibm.com>
 <20130123062613.GF13720@us.ibm.com>
 <20130226052646.GB21553@concordia>
 <20130226200343.GA21543@us.ibm.com>
 <20130227011725.GA5819@concordia>
 <20130306054826.GA14627@us.ibm.com>
 <20130312092740.GC30591@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312092740.GC30591@iris.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 08:27:40PM +1100, Paul Mackerras wrote:
> On Tue, Mar 05, 2013 at 09:48:26PM -0800, Sukadev Bhattiprolu wrote:
> > Michael Ellerman [michael@ellerman.id.au] wrote:
> > | I suspect Arnaldo was either waiting for an ACK from Ben, or was
> > | expecting Ben to take it?
> > 
> > Arnaldo, here is an updated patch. If it is acked by Paul Mackerras,
> > Michael Ellerman or Ben, will you add it to your tree so the whole
> > patchset comes from one place ?
> > 
> > Sukadev
> > 
> > ---
> > >From 50c7a46f14083c0ed10d66b7aed66ba76e798550 Mon Sep 17 00:00:00 2001
> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> > Date: Tue, 5 Mar 2013 21:20:56 -0800
> > Subject: [PATCH] [PATCH 5/6][v4]: perf Create a sysfs format entry for Power7 events
> > 
> > Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
> > which describes the format of the POWER7 PMU events.
> > 
> > This code is based on corresponding code in x86.
> > 
> > Changelog[v4]:  [Michael Ellerman, Paul Mckerras] The event format is different
> > 		for other POWER cpus. So move the code to POWER7-specific,
> > 		power7-pmu.c Also, the POWER7 format uses bits 0-19 not 0-20.
> > 
> > Changelog[v2]: [Jiri Osla] Use PMU_FORMAT_ATTR rather than duplicating code.
> > 
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> Acked-by: Paul Mackerras <paulus@samba.org>

Tested-by: Michael Ellerman <michael@ellerman.id.au>

cheers
