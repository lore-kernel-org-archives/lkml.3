Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaBCRlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:41:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36313 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaBCRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:41:20 -0500
Date: Mon, 3 Feb 2014 09:41:25 -0800
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: document "mach-virt" platform.
Message-ID: <20140203174125.GH4167@cbox>
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
 <52EA83D6.9050506@codeaurora.org>
 <20140203045638.GB4167@cbox>
 <52EF9D9F.5020600@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EF9D9F.5020600@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 08:46:07AM -0500, Christopher Covington wrote:
> Hi Christoffer,
> 
> On 02/02/2014 11:56 PM, Christoffer Dall wrote:
> > On Thu, Jan 30, 2014 at 11:54:46AM -0500, Christopher Covington wrote:
> >> I think it would be informative to provide pointers here to commonly used
> >> paravirtualized devices, especially VirtIO PCI/MMIO.
> > 
> > I disagree: that would only encourage limited testing or assumptions
> > about these specific devices when really this platform is just a
> > bare-bones platform driven by device tree which should make no
> > preference, whatsoever, about which devices are used with the platform.
> 
> I'd be all for clearly stating that no assumptions can be made. Perhaps you
> can explain though how providing less documentation will result in more
> testing? The assertion does not currently make sense to me.
> 
If the documentation states that this is commonly used with virtio/xen
pv drivers, then I'm afraid people will just assume that's the only
devices the platform is used with.

Any mention of specific devices or features steers the attention away
from the essential point of this documentation.

I don't see how adding this text helps.  Such documentation should go
elsewhere, in QEMU, or a Xen/KVM web page or something like that.

Anyway, I'm not religious about this point.

-Christoffer
