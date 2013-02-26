Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3BZF0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:26:53 -0500
Received: from ozlabs.org ([203.10.76.45]:52738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3BZF0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:26:49 -0500
Date: Tue, 26 Feb 2013 16:26:46 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        robert.richter@amd.com, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, benh@kernel.crashing.org
Subject: Re: [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event
 format
Message-ID: <20130226052646.GB21553@concordia>
References: <20130123062201.GA13720@us.ibm.com>
 <20130123062613.GF13720@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123062613.GF13720@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:26:13PM -0800, Sukadev Bhattiprolu wrote:
> 
> [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event format
> 
> Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
> which describes the format of a POWER cpu.

Did this patch go upstream? I don't see it.

If not, please don't merge it.

> The format of the event is the same for all POWER cpus at least in
> (Power6, Power7), so bulk of this change is common in the code common
> to POWER cpus.

No. The event format is different on most POWER cpus, in particular it
is different on Power6 and Power7, and will be different again on
Power8.

cheers
