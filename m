Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaGaGnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:43:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaGaGnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:43:21 -0400
Date: Thu, 31 Jul 2014 02:42:54 -0400
From: Rik van Riel <riel@redhat.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731024254.3dad1156@annuminas.surriel.com>
In-Reply-To: <20140731050454.GA9386@aaronlu.sh.intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
	<53D72FF5.90908@intel.com>
	<20140729023940.37b6aebc@annuminas.surriel.com>
	<20140729081712.GS20603@laptop.programming.kicks-ass.net>
	<20140729160437.4561742f@annuminas.surriel.com>
	<20140730021425.GA25023@aaronlu.sh.intel.com>
	<53D9003F.3050900@redhat.com>
	<20140731050454.GA9386@aaronlu.sh.intel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 13:04:54 +0800
Aaron Lu <aaron.lu@intel.com> wrote:

> On Wed, Jul 30, 2014 at 10:25:03AM -0400, Rik van Riel wrote:
> > On 07/29/2014 10:14 PM, Aaron Lu wrote:

> > >> +#define NUMA_SCALE 1024
> > >> +#define NUMA_MOVE_THRESH (5 * NUMA_SCALE / 100)
> > 
> > It would be good to see if changing NUMA_MOVE_THRESH to
> > (NUMA_SCALE / 8) does the trick.

FWIW, running with NUMA_MOVE_THRESH set to (NUMA_SCALE / 8)
seems to resolve the SPECjbb2005 threshold on my system.

I will run some more sanity tests later today...

-- 
All rights reversed.
