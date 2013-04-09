Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189Ab3DIGuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:50:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42735 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762735Ab3DIGux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:50:53 -0400
Message-ID: <5163BAA8.7040502@ti.com>
Date: Tue, 9 Apr 2013 12:22:24 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for cyclic
 channels
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <51626D88.8020809@ti.com> <20130408170956.GX30923@n2100.arm.linux.org.uk> <20130408171519.GP10155@atomide.com>
In-Reply-To: <20130408171519.GP10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013 10:45 PM, Tony Lindgren wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [130408 10:15]:
>> On Mon, Apr 08, 2013 at 09:11:04AM +0200, Peter Ujfalusi wrote:
>>> Russell,
>>>
>>> On 04/03/2013 01:17 PM, Peter Ujfalusi wrote:
>>>> cyclic DMA is only used by audio which needs DMA to be started without a
>>>> delay.
>>>> If the DMA for audio is started using the tasklet we experience random
>>>> channel switch (to be more precise: channel shift).
>>>>
>>>> Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
>>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>>> ---
>>>> Hi Russell,
>>>>
>>>> Instead of removing the tasklet we can identify the DMA channel used by audio
>>>> based on the cyclic flag of the channel.
>>>> I think this can be used as a short term solution to fix the audio channel shift
>>>> issue and later when we have the dynamic DMA channel allocation we can adjust
>>>> the code.
>>>
>>> Could you, please look at this patch?
>>
>> Now that I'm back from a short 4 day break, then yes, and the answer is
>> that it's fine.  Who's handling the patch?
> 
> I suggest Peter resend the patch with also Grant + Linus W cc:d so
> they can queue it unless there are other related patches pending
> somewhere else.
> 
Am curious on your suggestion. DMA engine patches are going via Vinod
Koul's tree so I think the $subject patch should follow the same
tree, No ?

Peter, if you plan to re-send, feel free to add my ack.


Regards,
Santosh

