Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3KHR7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:59:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:26069 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab3KHR7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:59:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432085501"
Message-ID: <527D2798.2010803@linux.intel.com>
Date: Fri, 08 Nov 2013 10:04:08 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        gregkh@linuxfoundation.org, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
References: <Pine.LNX.4.44L0.1311071053430.1401-100000@iolanthe.rowland.org> <xa1tzjpfxet7.fsf@mina86.com>
In-Reply-To: <xa1tzjpfxet7.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 11/08/2013 04:23 AM, Michal Nazarewicz wrote:
> On Thu, Nov 07 2013, Alan Stern wrote:
>> What happens if the userspace daemon writes to epfile but the host
>> changes the config or altsetting before all the data can be sent?  Does
>> the remaining data get flushed?
>
> Each read and write is mapped to a single request, so the usual.
>
>> I'm still a little unclear on this.  Disabling the function ought to
>> have much the same effect as changing the config or altsetting: Writes
>> to endpoint files should be flushed and reads should be terminated.
>> Otherwise you would end up sending stale data to the host or reading
>> data that the daemon isn't prepared for.
>
> You may have a point here.  I'll try to prepare a patch over the weekend.

It looks like our patches are going to have dependence.
If you send yours this weekend, I'll wait to send new version of this
patch of mine on top of yours.

Br, David Cohen
