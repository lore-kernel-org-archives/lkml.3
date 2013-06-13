Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3FMPgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:36:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:19087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab3FMPgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,859,1363158000"; 
   d="scan'208";a="254573459"
Message-ID: <51B9E6E0.8040208@linux.intel.com>
Date: Thu, 13 Jun 2013 18:36:00 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        sockperf-dev@googlegroups.com, Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v3 net-next 3/4] net: change sysctl_net_ll_poll into an
 unsigned int
References: <20130613144613.4875.46858.stgit@ladj378.jer.intel.com>  <20130613144645.4875.47741.stgit@ladj378.jer.intel.com> <1371137471.3252.110.camel@edumazet-glaptop>
In-Reply-To: <1371137471.3252.110.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/2013 18:31, Eric Dumazet wrote:
> On Thu, 2013-06-13 at 17:46 +0300, Eliezer Tamir wrote:
>> +extern unsigned int sysctl_net_ll_poll __read_mostly;
>>
>
> Oh well, you re-introduce the overflow
>
> hint : you defined
>
> #define USECS_TO_NS(us) (us << 10)

ouch!
(thanks)
