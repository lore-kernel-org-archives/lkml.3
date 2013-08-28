Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3H1PJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:09:19 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61434 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3H1PJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:09:18 -0400
Message-ID: <521E1292.5060709@gmail.com>
Date: Wed, 28 Aug 2013 20:39:06 +0530
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] xHCI: Fixing xhci_readl definition and function call
References: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com> <20130828071304.GO6329@mwanda>
In-Reply-To: <20130828071304.GO6329@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 August 2013 12:43 PM, Dan Carpenter wrote:
> On Mon, Aug 26, 2013 at 07:38:57AM +0530, Kumar Gaurav wrote:
>> This patch redefine function xhci_readl.xhci_readl function doesn't use xhci_hcd argument.
>> Hence there is no need of keeping it in the function arguments.
>>
>> Redefining this function breaks other functions which calls this function.
>> This phatch also correct those calls in xhci driver.
>>
>> Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
>> ---
> Could you put a list of changes since v2 here?:
>
> v3:  blah blah changelog mostly.
>
> Also this doesn't apply for me against linux-next.
>
> regards,
> dan carpenter
>
There's no change from v2. I was sending the same patch again because 
the last one was lacking good description and i was told (or as i 
understood) that if I'm sending the same patch or patch for the same 
purpose as previous then i should increment version so i did.

I had developed this patch against linux-git, haven't tested that on 
linux-next as i haven't cloned  linux-next yet.

I've started cloning linux-next and as it's not applying on linux-next, 
I'll try it on linux-next (once i cloned it)  and will send again.

Regards
Kumar Gaurav
