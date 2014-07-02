Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaGBPeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:34:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:17561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbaGBPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:34:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="564222679"
Date: Wed, 2 Jul 2014 08:34:07 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Message-ID: <20140702153407.GN19781@tassilo.jf.intel.com>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
 <1403910612-8754-2-git-send-email-andi@firstfloor.org>
 <20140702122902.GC19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702122902.GC19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 02:29:02PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 27, 2014 at 04:10:11PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > As already discussed earlier in email.
> 
> Is an entirely inappropriate start for a Changelog. Do not assume prior
> knowledge. If its relevant include it here without reference.

Thanks. Do you have any other comments?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
