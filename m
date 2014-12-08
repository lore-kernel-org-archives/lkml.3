Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaLHQue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:50:34 -0500
Received: from bar.sig21.net ([80.81.252.164]:46210 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaLHQuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:50:32 -0500
Date: Mon, 8 Dec 2014 17:50:16 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141208165016.GA28471@sig21.net>
References: <5481794E.4050406@broadcom.com>
 <20141205183945.GE31222@e104818-lin.cambridge.arm.com>
 <20141205185303.GG31222@e104818-lin.cambridge.arm.com>
 <20141208125538.GA26983@sig21.net>
 <20141208155556.GL16185@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208155556.GL16185@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 03:55:57PM +0000, Catalin Marinas wrote:
> On Mon, Dec 08, 2014 at 12:55:38PM +0000, Johannes Stezenbach wrote:
> > On Fri, Dec 05, 2014 at 06:53:03PM +0000, Catalin Marinas wrote:
> > > 
> > > BTW, if you really have a PL310-like L2 cache, have a look at some
> > > patches (I've seen similar symptoms) and make sure your configuration is
> > > correct:
> > > 
> > > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6395/1
> > > 
> > > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6529/1
> > > 
> > > The first one is vexpress specific. The second one was eventually
> > > discarded by Russell (I don't remember the reason, I guess it's because
> > > SoC code is supposed to set the right bits in there anyway). In your
> > > case, such bits may be set up by firmware, so Linux cannot fix anything
> > > up.
> > 
> > How do you avoid the unpredictable behavior mentioned in the
> > PL310 TRM when the Shared Attribute Invalidate Enable bit is set?
> > http://infocenter.arm.com/help/topic/com.arm.doc.ddi0246h/Ceggcfcj.html
> 
> So you talk about "Shared Attribute _Invalidate_ Enable" (bit 13) while
> I talk about "Shared Attribute _Override_ Enable" (bit 22).
> 
> In addition, Shared _Invalidate_ behaviour can only be enabled if Shared
> Attribute _Override_ Enable bit is not set.

Yeah, I got confused, sorry for the noise.

Thanks,
Johannes
