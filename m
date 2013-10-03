Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3JCSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:16:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:62356 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab3JCSQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:16:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1027,1371106800"; 
   d="scan'208";a="369409016"
Date: Thu, 3 Oct 2013 11:16:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 11/11] perf: Avoid uninitialized sample type reference in
 __perf_event__output_id_sample
Message-ID: <20131003181652.GH2125@tassilo.jf.intel.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-12-git-send-email-andi@firstfloor.org>
 <20131002085730.GD12926@twins.programming.kicks-ass.net>
 <20131002172507.GG2125@tassilo.jf.intel.com>
 <20131002173619.GW3081@twins.programming.kicks-ass.net>
 <20131003064201.GF25345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003064201.GF25345@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Forcing multiple, unnecessary rounds of emails instead of clearly 
> volunteering all technical information that is related to the matter is 
> something Andi is still doing routinely.

Sorry all the information was in the full email thread
(including the intro). And the patch description 
clearly described the problem in your code.

As the patches spanned many subsystems you were only copied
on the patches that affect your subsystem, and not on
the intro (as git send-email doesn't seem to support that)

Here are possible alternatives. Please let me know which ones
you prefer and I'll try to adapt to your specific preferences
in the future:

[ ] Always copy you guys on all patches of 
subsystem spanning patch kits that are mostly of no relevance
to you. 

[ ] Repeat the complete intro in every patch.

[ ] You think uninitialized are not a problem and you
don't want to see any patches related to that.

[ ] You are not interested in fixing static checker problems in your
subsystem and don't want to see any patches related to that.

Thanks.

-Andi
