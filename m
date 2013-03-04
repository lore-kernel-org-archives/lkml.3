Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3CDIqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:46:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:54311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab3CDIqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:46:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="294394268"
Message-ID: <51345F77.6060503@linux.intel.com>
Date: Mon, 04 Mar 2013 10:46:47 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com> <51344F54.8060809@gmail.com> <5134592E.6050508@linux.intel.com>
In-Reply-To: <5134592E.6050508@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>
>>
>>
>> A dumb question: is bypassing tcpdump/netfilters/qdisc etc. what we
>> always want? Isn't this a security issue?
>
> We are not bypassing any of the regular stack checks/hooks, we call the
> normal netif_rx_skb().
correction, netif_receive_skb()
