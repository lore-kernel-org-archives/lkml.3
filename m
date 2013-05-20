Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3ETO7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:59:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:35312 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3ETO70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:59:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="340548930"
Message-ID: <519A3A49.60604@linux.intel.com>
Date: Mon, 20 May 2013 17:59:21 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v3 net-next 2/4] tcp: add TCP support for low latency
 receive poll.
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>  <20130520101612.14133.95780.stgit@ladj378.jer.intel.com> <1369057742.3301.168.camel@edumazet-glaptop>
In-Reply-To: <1369057742.3301.168.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 20/05/2013 16:49, Eric Dumazet wrote:
> On Mon, 2013-05-20 at 13:16 +0300, Eliezer Tamir wrote:
>>
>> +config INET_LL_TCP_POLL
>> +	bool "Low Latency TCP Receive Poll"
>> +	depends on INET_LL_RX_POLL
>> +	default n
>> +	---help---
>> +	  TCP support for Low Latency TCP Queue Poll.
>> +	  (For network cards that support this option.)
>> +	  Add support to the TCP stack for direct polling of the network card.
>> +
>> +	  If unsure, say N.
>> +
>
> Oh well, code is small and already guarded by CONFIG_INET_LL_RX_POLL

I will remove the separate config option.

