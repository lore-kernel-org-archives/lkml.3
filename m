Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaAHL3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:29:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55473 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaAHL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:29:08 -0500
Date: Wed, 8 Jan 2014 12:28:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 0/2] perf/x86: various RAPL improvements and fixes
Message-ID: <20140108112832.GB31570@twins.programming.kicks-ass.net>
References: <1389176153-3128-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389176153-3128-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:15:51AM +0100, Stephane Eranian wrote:
> This short patch series provides the following improvements
> to the RAPL support for perf_events:
>  - support for RAPL PP1 energy counter
>  - fix struct perf_event active_list field initialization
> 
> The PP1 counter maps to the builtin graphic card for client
> processors. that is why it is called energy-gpu.
> 
> The new energy event is:
>  - name: power/energy-gpu/
>  - code: 0x4
>  - unit: Joules
>  - scaling factor: 2^-32 Joules.
> 
> In v2, we renamed energy-pp1 to energy-gpu. We dropped the Haswell
> Celeron patch because it is committed already. But we add a fix for
> the broken initialization of the active_entry list.
> 

Thanks!
