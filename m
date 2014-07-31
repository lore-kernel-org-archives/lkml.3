Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaGaHbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:31:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:45343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaGaHbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="463475727"
Message-ID: <53D9F0D7.7030002@intel.com>
Date: Thu, 31 Jul 2014 15:31:35 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
CC: "Kleen, Andi" <andi.kleen@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com> <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com> <20140725081033.GV3935@laptop> <53D216A4.3090600@intel.com> <20140725140652.GA6758@twins.programming.kicks-ass.net> <53D5B45E.4030403@intel.com> <20140728065255.GI6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140728065255.GI6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 02:52 PM, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 10:24:30AM +0800, Yan, Zheng wrote:
> 
>> I don't think this method works for interrupt threshold > 1 case. When collision
>> happens, the hardware only create one PEBS record. The status in next record has
>> nothing to do with the collision record.
> 
> Andi previously stated that the hardware will always generate a record
> for each event:
> 
>   http://marc.info/?l=linux-kernel&m=140129731708247
> 
> Please lock yourselves in room and do not come out until you can give a
> straight and coherent answer.
> 

Andi,

please confirm this

Regards
Yan, Zheng

