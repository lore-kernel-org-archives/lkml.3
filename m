Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3ETK0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:26:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:45533 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3ETK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="340443125"
Message-ID: <5199FA39.9090001@linux.intel.com>
Date: Mon, 20 May 2013 13:26:01 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2 net-next 0/4] net: low latency Ethernet device polling
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com> <CAJZOPZJzVykmBH5FFQBVuztAFGRMOPT-GKABiewG6b4pnKVUeA@mail.gmail.com> <51992713.30705@linux.intel.com> <CAJZOPZ+8zKfuuUhOwzz6WKm6do6N25B1DAmv+aOipSLbvdh6LA@mail.gmail.com>
In-Reply-To: <CAJZOPZ+8zKfuuUhOwzz6WKm6do6N25B1DAmv+aOipSLbvdh6LA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/2013 22:56, Or Gerlitz wrote:
> On Sun, May 19, 2013 at 10:25 PM, Eliezer Tamir <
> eliezer.tamir@linux.intel.com> wrote:
>
>> On 19/05/2013 22:06, Or Gerlitz wrote:
>>
>>> Last time you've placed a copy of the patchset in the rfc branch of
>>> git://github.com/jbrandeb/lls.**git <http://github.com/jbrandeb/lls.git> - can you repost there V2 too?
>>>
>>> Or.
>>>
>>>   BTW did you try the last version on your HW?
>>
>
>
> nope, you didn't provide mlx4 patch :( we will look into that ...

I would never risk compromising your job security like that
