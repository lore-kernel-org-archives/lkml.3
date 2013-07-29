Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3G2Nmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:42:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43072 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab3G2Nmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:42:54 -0400
Message-ID: <51F6713A.1080403@ti.com>
Date: Mon, 29 Jul 2013 09:42:18 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH 0/5] mm: ARM nobootmem and few dma_mask fixes
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <20130726151021.GU24642@n2100.arm.linux.org.uk> <51F2A3AA.4060801@ti.com> <20130729111503.GG24642@n2100.arm.linux.org.uk> <51F66D94.9060706@ti.com> <20130729134012.GK24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130729134012.GK24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 July 2013 09:40 AM, Russell King - ARM Linux wrote:
> On Mon, Jul 29, 2013 at 09:26:44AM -0400, Santosh Shilimkar wrote:
>> On Monday 29 July 2013 07:15 AM, Russell King - ARM Linux wrote:
>>> Would you mind putting them all in the patch system, I can add the acks
>>> should anyone supply them later, and I'll repost them along with my set
>>> of dma-mask patches.  Thanks.
>>>
>> Done.
>> 7794/1, 7795/1, 7796/1, 7797/1, 7798/1, 7799/1
>>
>> Didn't know how to get XXXX/1,2,3,4... pushed into the tracker.
>> BTW, I have also pushed the patched on my git tree branch [1] just
>> in case you or some one needs it.
> 
> Thanks.  I'd prefer not to have them as stable commits yet because should
> we get acks from Jens, Jejb or cjb, we will need to add their acks to them.
>
right.
 
> My dma-masks branch is still very much unstable at the moment (which is
> why its not published) but I shall be posting the patches during this
> week.
> 
Sure.

Regards,
Santosh
