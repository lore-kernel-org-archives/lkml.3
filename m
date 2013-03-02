Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3CBRCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 12:02:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:36208 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3CBRCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 12:02:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,768,1355126400"; 
   d="scan'208";a="293949245"
Message-ID: <513230A7.6050301@linux.intel.com>
Date: Sat, 02 Mar 2013 19:02:31 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eliezer.tamir@linux.jf.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com> <20130301.162400.1645765127882618751.davem@davemloft.net>
In-Reply-To: <20130301.162400.1645765127882618751.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 23:24, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
> Date: Wed, 27 Feb 2013 09:55:49 -0800
>
>> This patchset adds the ability for the socket layer code to poll directly
>> on an Ethernet device's RX queue. This eliminates the cost of the interrupt
>> and context switch and with proper tuning allows us to get very close
>> to the HW latency.
>>
>> This is a follow up to Jesse Brandeburg's Kernel Plumbers talk from last year
>> http://www.linuxplumbersconf.org/2012/wp-content/uploads/2012/09/2012-lpc-Low-Latency-Sockets-slides-brandeburg.pdf
>
> I just wanted to say that I like this work a lot.
>
> It proves a lot of things I try to impress upon people who talk about
> how RDMA is such a "must have" because the software stack can't
> possibly give anything near HW latency.
>
> Obviously such arguments are complete bullshit as is shown by these
> changes.
>
> This is exactly the kind of approach that makes sense rather than
> trying to put entire TCP stacks in the network card firmware.
>
> Thanks again for doing this work and I look forward to applying
> this stuff once all the kinks are worked out.  The folks in the
> Intel NIC group continue to impress me.

It would really help us to hear opinions on the open issues we listed.

Thanks,
Eliezer
