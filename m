Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab3DIHT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:19:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42647 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935014Ab3DIHT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:19:56 -0400
Message-ID: <5163C103.8020101@ti.com>
Date: Tue, 9 Apr 2013 09:19:31 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for cyclic
 channels
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <51626D88.8020809@ti.com> <20130408170956.GX30923@n2100.arm.linux.org.uk> <20130408171519.GP10155@atomide.com> <5163BAA8.7040502@ti.com>
In-Reply-To: <5163BAA8.7040502@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 08:52 AM, Santosh Shilimkar wrote:
>> I suggest Peter resend the patch with also Grant + Linus W cc:d so
>> they can queue it unless there are other related patches pending
>> somewhere else.
>>
> Am curious on your suggestion. DMA engine patches are going via Vinod
> Koul's tree so I think the $subject patch should follow the same
> tree, No ?

AFAIK Vinod should be the correct person to pick it up, but I can CC Grant and
Linus W as well.

> Peter, if you plan to re-send, feel free to add my ack.

I'll figure out which stable release should have this applied and will resend.

-- 
Péter
