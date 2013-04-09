Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937582Ab3DIKUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:20:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51733 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935573Ab3DIKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:20:40 -0400
Message-ID: <5163EB61.3000507@ti.com>
Date: Tue, 9 Apr 2013 12:20:17 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for cyclic
 channels
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <51626D88.8020809@ti.com> <20130408170956.GX30923@n2100.arm.linux.org.uk> <20130408171519.GP10155@atomide.com> <5163BAA8.7040502@ti.com> <5163C103.8020101@ti.com> <20130409072600.GA31193@intel.com>
In-Reply-To: <20130409072600.GA31193@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 09:26 AM, Vinod Koul wrote:
> Yes it should go thru dmaengine tree, sorry was travelling hence the delay, pls
> resend the patch and I will do the needful

I already have the patch rebased on today's linux-next, just waiting for
Russell to confirm that I can add his Acked-by to the patch.
I take this from Russell as ACK: "Now that I'm back from a short 4 day break,
then yes, and the answer is that it's fine.  Who's handling the patch?"

But I want to be sure I can add that line...

-- 
Péter
