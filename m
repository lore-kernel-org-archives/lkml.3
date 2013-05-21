Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3EUGyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:54:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:14893 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3EUGyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:54:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,712,1363158000"; 
   d="scan'208";a="337452123"
Message-ID: <519B1A2B.4010909@linux.intel.com>
Date: Tue, 21 May 2013 09:54:35 +0300
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
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com> <20130520101622.14133.21998.stgit@ladj378.jer.intel.com> <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
In-Reply-To: <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2013 23:20, Or Gerlitz wrote:
> On Mon, May 20, 2013 at 1:16 PM, Eliezer Tamir
> <eliezer.tamir@linux.intel.com> wrote:
>> Add the ixgbe driver code implementing ndo_ll_poll.
>> It should be easy for other drivers to do something similar
>> in order to enable support for CONFIG_INET_LL_RX_POLL
>
> I am not sure,

Willem ported this to <some undisclosed HW that they use at Google>, his 
feedback was that it was not a major effort.
