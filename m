Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966513Ab3E2PBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:01:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:21958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966245Ab3E2PBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:01:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="scan'208";a="342000266"
Message-ID: <51A61844.1010403@linux.intel.com>
Date: Wed, 29 May 2013 18:01:24 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: yaniv saar <yaniv.mellanox@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com> <20130529063935.27486.18610.stgit@ladj378.jer.intel.com> <1369834647.5109.15.camel@edumazet-glaptop> <51A60A42.20905@linux.intel.com> <CALuTh9EvzhDaqnVV35wytNg6kJhm+HbOjp5tdxWS9bCTVM5YSA@mail.gmail.com>
In-Reply-To: <CALuTh9EvzhDaqnVV35wytNg6kJhm+HbOjp5tdxWS9bCTVM5YSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2013 17:20, yaniv saar wrote:
> Hi Eliezer,
>
> (If I'm too late then a future note...)
> Why make polling a system-wide configuration?
> Wouldn't it make more sense to implement a sock option?
> An even better solution might be aggregation/combination of both types of
> configurations.
>
> -- Yaniv Sa'ar

We plan on adding a socket option in the future.

-Eliezer
