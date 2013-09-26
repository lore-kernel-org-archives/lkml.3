Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3IZUfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:35:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:51614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3IZUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,988,1371106800"; 
   d="scan'208";a="410029839"
Message-ID: <52449B68.6060802@linux.intel.com>
Date: Thu, 26 Sep 2013 13:39:04 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: add support for Merrifield
References: <1380225704-28923-1-git-send-email-david.a.cohen@linux.intel.com> <20130926201454.GC16369@kroah.com>
In-Reply-To: <20130926201454.GC16369@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 09/26/2013 01:14 PM, Greg KH wrote:
> On Thu, Sep 26, 2013 at 01:01:44PM -0700, David Cohen wrote:
>> Add PCI id for Intel Merrifield
>>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>   drivers/usb/dwc3/dwc3-pci.c | 2 ++
>>   1 file changed, 2 insertions(+)
>
> Nice, Felipe, mind if I just pick this up now, as I'm applying USB
> patches at the moment...
>
> David, this should go to older kernels as well, right?

This was first tested on kernel 3.10. So I can't ack any older kernel at 
this moment.

Br, David Cohen

>
> thanks,
>
> greg k-h
>

