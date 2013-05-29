Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966760Ab3E2PE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:04:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:16347 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966381Ab3E2PE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:04:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="scan'208";a="342001888"
Message-ID: <51A618F3.7050407@linux.intel.com>
Date: Wed, 29 May 2013 18:04:19 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v6 net-next 1/5] net: add napi_id and hash
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>  <20130529063925.27486.46649.stgit@ladj378.jer.intel.com> <1369832201.5109.8.camel@edumazet-glaptop>
In-Reply-To: <1369832201.5109.8.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2013 15:56, Eric Dumazet wrote:
> On Wed, 2013-05-29 at 09:39 +0300, Eliezer Tamir wrote:
>> Adds a napi_id and a hashing mechanism to lookup a napi by id.
>> This will be used by subsequent patches to implement low latency
>> Ethernet device polling.
>> Based on a code sample by Eric Dumazet.
>>
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>
> OK this looks good enough for inclusion.
>
> If a v7 ever is submitted, please add a 'static' for
>
> static DEFINE_SPINLOCK(napi_hash_lock);
> static unsigned int napi_gen_id;
> static DEFINE_HASHTABLE(napi_hash, 8);
>

I will post a v7 along with the changes you suggested to 2/5, I will 
wait a bit to see if there are other things to fix.

Thanks,
Eliezer
