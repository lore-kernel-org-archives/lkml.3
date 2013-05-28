Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab3E1I3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:29:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:31601 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449Ab3E1I3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:29:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,756,1363158000"; 
   d="scan'208";a="344249822"
Message-ID: <51A46ADD.5070101@linux.intel.com>
Date: Tue, 28 May 2013 11:29:17 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v5 net-next 0/5] net: low latency Ethernet device polling
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com> <1369701340.3301.504.camel@edumazet-glaptop>
In-Reply-To: <1369701340.3301.504.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/2013 03:35, Eric Dumazet wrote:
> On Mon, 2013-05-27 at 10:43 +0300, Eliezer Tamir wrote:
>> Hello Dave,
>>
>> There are many small changes from the last time.
>> The two big changes are:
>> * Skb and sk now store a napi_id instead of a pointer.
>> * Very naive poll/select support. There is a dramatic improvement in both
>>    latencey and jitter, but clearly more work needs to be done here.
>
> Sorry I couldn't figure out how poll() was supported.

It's the fs/select changes in the second patch.
Should I will split it into a separate one? (it's just 7 lines)

-Eliezer
