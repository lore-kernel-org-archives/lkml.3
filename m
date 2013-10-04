Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3JDWEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:04:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:40568 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab3JDWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:04:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="303345638"
Message-ID: <524F3C64.70506@linux.intel.com>
Date: Fri, 04 Oct 2013 15:08:36 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: g_ffs: fix compilation warning
References: <1380923326-18546-1-git-send-email-david.a.cohen@linux.intel.com> <20131004215156.GA10629@kroah.com> <524F3B4A.7070107@linux.intel.com>
In-Reply-To: <524F3B4A.7070107@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 03:03 PM, David Cohen wrote:
> On 10/04/2013 02:51 PM, Greg KH wrote:
>> On Fri, Oct 04, 2013 at 02:48:46PM -0700, David Cohen wrote:
>>> Due to lack of "u_ether.h" header file, g_ffs.c compiles with following
>>> warning:
>>
>> It does?  In what tree/branch/release is this happening?
>
> This is intended for Linus' 3.12-rc3. Haven't checked any other kernel.
>
> In my compilation I disabled USB Host support and enabled DWC3 (gadget
> only) with ePCI + NOP_USB_XCEIV.

After checking again this patch is not fixing properly.
u_ether.h is conditionally included.

I'll solve it in another way. Please do not consider this patch anymore.

BR, David

>
> Br, David
>
>>
>> thanks,
>>
>> greg k-h
>>
>

