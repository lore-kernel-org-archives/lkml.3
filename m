Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbbAUTMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:12:30 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:42510 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbbAUTMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:12:22 -0500
X-IronPort-AV: E=Sophos;i="5.09,443,1418112000"; 
   d="scan'208";a="55279774"
Message-ID: <54BFFA42.4010506@broadcom.com>
Date: Wed, 21 Jan 2015 11:13:06 -0800
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <linux@prisktech.co.nz>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sbranden@broadcom.com>,
        <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>
Subject: Re: [PATCHv3 1/2] usb: ehci-platform: add support for multiple phys
 per controller
References: <Pine.LNX.4.44L0.1501211002380.1670-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1501211002380.1670-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Alan. I did run check patch and I had no errors or warnings.

I explained my changes in v3 in the cover patch, did that not come 
through or is it convention to do it in the individual patch?

Is the ack for the ohci patch as well? Thanks

Arun Ramamurthy

On 15-01-21 07:03 AM, Alan Stern wrote:
> On Mon, 19 Jan 2015 arun.ramamurthy@broadcom.com wrote:
>
>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>
>> Added support for cases where one controller is connected
>> to multiple phys.
>>
>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> Tested-by: Scott Branden <sbranden@broadcom.com>
>> ---
>
> Right here is where you should explain how v3 of this patch is
> different from v2.
>
> Anyway, it looks good.
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
> Did you run it through checkpatch.pl?
>
> Alan Stern
>
