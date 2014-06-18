Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaFRQFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:05:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:32431 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbaFRQFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:05:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="447090724"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Liang\, Kan" <kan.liang@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen\, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH 1/2] perf: ignore LBR and offcore_rsp.
References: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
	<20140618155916.GZ6758@twins.programming.kicks-ass.net>
Date: Wed, 18 Jun 2014 09:04:02 -0700
In-Reply-To: <20140618155916.GZ6758@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 18 Jun 2014 17:59:16 +0200")
Message-ID: <87lhsu8arx.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> This order indicates Andi is the author; but there's no corresponding
> From.

I wrote an early version of the patch, but Kan took it over and extended
it. So both are authors.

BTW Kan you may want to use git send-email to get standard format.

>
>>     Signed-off-by: Kan Liang <kan.liang@intel.com>
>
> And here I thought that Andi was of the opinion that if you set CPUID to
> indicate a particular CPU you had better also handle all its MSRs.

Yes, philosophically that would be the right way,
but we needed a short term fix to stop things from crashing, and that
was the simplest.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
