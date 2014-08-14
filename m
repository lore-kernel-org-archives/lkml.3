Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaHNOaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:30:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:29564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbaHNOaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="372386517"
Date: Thu, 14 Aug 2014 07:30:09 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Message-ID: <20140814143009.GO5803@tassilo.jf.intel.com>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-5-git-send-email-andi@firstfloor.org>
 <CABPqkBTnZ8SF8TPPMxcY+jPvwQhv+3gki86dnNVgBbAJ_RPdkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTnZ8SF8TPPMxcY+jPvwQhv+3gki86dnNVgBbAJ_RPdkg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I understand all your points, but there's no alternative.
The only other way would be to disable INST_RETIRED.ALL.

-Andi
