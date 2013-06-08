Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3FHSGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 14:06:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:50646 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab3FHSGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 14:06:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,828,1363158000"; 
   d="scan'208";a="350350122"
Message-ID: <51B372AE.2080705@linux.intel.com>
Date: Sat, 08 Jun 2013 21:06:38 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v9 net-next 0/7] net: low latency Ethernet device polling
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com> <20130607.144805.1227746282017227022.davem@davemloft.net>
In-Reply-To: <20130607.144805.1227746282017227022.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 00:48, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Wed, 05 Jun 2013 13:34:00 +0300
>
>> And here is v9.
>> Except for typo fixes in comments/description, only 2/7 and 5/7 were changed.
>>
>> Thanks to everyone for their input.
>
> Since there is some discussion about the way the poll() bits work,
> might I suggest you make a v10 without the poll stuff, which I will
> apply to net-next, and then you can build the poll stuff on top of
> that?

I will do that.

Thanks,
Eliezer
