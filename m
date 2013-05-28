Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273Ab3E1NlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:41:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:15635 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934222Ab3E1NlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:41:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="247649540"
Message-ID: <51A4B3F4.9000006@linux.intel.com>
Date: Tue, 28 May 2013 16:41:08 +0300
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
Subject: Re: [PATCH v5 net-next 1/5] net: add napi_id and hash
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>   <20130527074401.29882.98135.stgit@ladj378.jer.intel.com>  <1369700905.3301.499.camel@edumazet-glaptop>  <51A464B9.5080106@linux.intel.com> <1369748280.3301.534.camel@edumazet-glaptop>
In-Reply-To: <1369748280.3301.534.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/2013 16:38, Eric Dumazet wrote:
> On Tue, 2013-05-28 at 11:03 +0300, Eliezer Tamir wrote:
>
>> With an atomic we don't need the RTNL in any of the napi_id functions.
>> One less thing to worry about when we try to remove the RTNL.
>
> OK but we'll need something to protect the lists against concurrent
> insert/deletes.
>
> A spinlock or a mutex.

OK
