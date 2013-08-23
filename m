Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3HWHG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:06:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:61671 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab3HWHGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,939,1367996400"; 
   d="scan'208";a="367234488"
Message-ID: <521709E7.7000302@linux.intel.com>
Date: Fri, 23 Aug 2013 10:06:15 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, eilong@broadcom.com,
        amirv@mellanox.com, erdnetdev@gmail.com, willemb@google.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com> <20130822.131402.362258965058758270.davem@davemloft.net>
In-Reply-To: <20130822.131402.362258965058758270.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/2013 23:14, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Date: Wed, 21 Aug 2013 13:39:54 +0300
> 
>> +	SK_LL_STATE_MISS_2,	/* data came through napi poll twice in a row */
> 
> Please rename this to SK_LL_STATE_MISS_MULTI or something like that.
> 
> Thanks.

OK
