Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbaGCPwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:52:42 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171AbaGCPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:52:40 -0400
Date: Thu, 3 Jul 2014 17:52:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kan.liang@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Message-ID: <20140703155237.GQ5714@two.firstfloor.org>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
 <20140703073321.GU19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703073321.GU19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If there's active LBR users out there, we should refuse to enable PT and
> vice versa. 

This doesn't work, e.g. hardware debuggers can take over at any time.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
