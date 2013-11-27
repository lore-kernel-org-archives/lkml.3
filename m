Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab3K0Tp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:45:26 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51822 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3K0TpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:45:25 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131125194631.GE2879@titan.lakedaemon.net>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
	<20131125194631.GE2879@titan.lakedaemon.net>
Date: Wed, 27 Nov 2013 11:45:24 -0800
Message-ID: <CAOesGMhRYg4L72v8XCCSwSnLhYuZ6+aBTxPGNvVn=n=xpVm71A@mail.gmail.com>
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
From: Olof Johansson <olof@lixom.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:46 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Mon, Nov 25, 2013 at 07:39:25PM +0000, Jason Cooper wrote:
>> The following commit:
>>
>>   54f8d501e842 dmaengine: remove DMA unmap from drivers
>>
>> removed the last caller to mv_desc_get_dest_addr(), creating the
>> warning:
>>
>>   drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
>>   but not used [-Wunused-function]
>>
>> Remove it.
>>
>> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
>> ---
>>  drivers/dma/mv_xor.c | 6 ------
>>  1 file changed, 6 deletions(-)
>
> Gah!  I sent too fast.  I meant to mention that I have this in my
> mvebu/fixes branch, which gets merged into -next each night.  (The
> warning was bugging me :) )
>
> Just let me know when you take it and I'll drop it from my branches.

Hmm. Please don't add patches for other subsystems into your -next
tree, since then there is no indication for those of us who follow
-next that the patch is not yet merged by the appropriate maintainer.


-Olof
