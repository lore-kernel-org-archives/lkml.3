Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaGaOol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:44:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:12517 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaGaOok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,772,1400050800"; 
   d="scan'208";a="463603565"
From: Andi Kleen <andi@firstfloor.org>
To: "Yan\, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, peterz@infradead.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
	<1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
	<20140725081033.GV3935@laptop> <53D216A4.3090600@intel.com>
	<20140725140652.GA6758@twins.programming.kicks-ass.net>
	<53D5B45E.4030403@intel.com>
	<20140728065255.GI6758@twins.programming.kicks-ass.net>
	<53D9F0D7.7030002@intel.com>
Date: Thu, 31 Jul 2014 07:44:12 -0700
In-Reply-To: <53D9F0D7.7030002@intel.com> (Zheng Yan's message of "Thu, 31 Jul
	2014 15:31:35 +0800")
Message-ID: <87a97pr3k3.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yan, Zheng" <zheng.z.yan@intel.com> writes:
>> 
>> Please lock yourselves in room and do not come out until you can give a
>> straight and coherent answer.
>> 
>
> Andi,
>
> please confirm this

The hardware can merge PEBS events that happen nearby each other. 
I was wrong earlier in stating the opposite.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
