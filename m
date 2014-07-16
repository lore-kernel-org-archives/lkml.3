Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbaGPBNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:13:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:59498 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaGPBNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,668,1400050800"; 
   d="scan'208";a="457460750"
Message-ID: <53C5D19A.8020608@intel.com>
Date: Wed, 16 Jul 2014 09:12:58 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 0/7] perf, x86: large PEBS interrupt threshold
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com> <20140715100216.GY9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140715100216.GY9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 06:02 PM, Peter Zijlstra wrote:
> 
> 
> The first two patches are the same patches as from the LBR callstack
> series, right?
> 
Yes

Yan, Zheng
