Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbaHZJBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:01:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:10623 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbaHZJA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,402,1406617200"; 
   d="scan'208";a="589917102"
Date: Tue, 26 Aug 2014 12:00:32 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>, Kumar P Mahesh <mahesh.kumar.p@intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] intel_idle: add idle values for Cherrytrail/Braswell
Message-ID: <20140826090032.GN1660@lahna.fi.intel.com>
References: <1408701508-13636-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408707540-12393-1-git-send-email-mika.westerberg@linux.intel.com>
 <53F74E5D.2040108@linux.intel.com>
 <20140825101200.GH1660@lahna.fi.intel.com>
 <53FBF328.1080205@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FBF328.1080205@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 10:38:32AM +0800, Li, Aubrey wrote:
> On 2014/8/25 18:12, Mika Westerberg wrote:
> > On Fri, Aug 22, 2014 at 10:06:21PM +0800, Li, Aubrey wrote:
> >> On 2014/8/22 19:39, Mika Westerberg wrote:
> >>> From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
> >>>
> >>> Cherrytrail/Braswell is a successor of Intel Baytrail but has slighly
> >>> different CPU idle values and latencies.
> >>>
> >>> Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
> >>> Signed-off-by: Alan Cox <alan@linux.intel.com>
> >>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >>> ---
> >>> I learned from Mahesh that C1e, C4 and S0i2 states are deprecated so those
> >>> are now removed.
> >>
> >> If the platform has ACPI supported, I believe Len wants to see what
> >> C-states number exported by ACPI.
> >>
> >> Please boot the machine with "intel_idle.max_cstate=0" to disable
> >> intel_idle, then post the output of the following commands
> > 
> > OK, here goes:
> 
> ACPI exposes 0x58 as C6 mwait hint while the patch proposes 0x52 for C6.
> Can you please remove "intel_idle.max_cstate=0" and run "dmesg | grep
> idle" again to see how many C6 supports in CPUID enumeration?

[   16.685769] intel_idle: MWAIT substates: 0x33000020
[   16.691236] intel_idle: v0.4 model 0x4C
[   16.695539] intel_idle: lapic_timer_reliable_states 0xffffffff
