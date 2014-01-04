Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaAFHaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:30:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59261 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbaAFHaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:30:05 -0500
Date: Sat, 4 Jan 2014 11:19:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v4 0/6] Krait L1/L2 EDAC driver
Message-ID: <20140104101901.GA4439@nazgul.tnic>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 12:14:11PM -0800, Stephen Boyd wrote:
> This patchset adds support for the Krait L1/L2 cache error detection
> hardware. The first patch fixes a generic framework bug. The next
> two patches lay the groundwork for this driver to be added by 
> exporting percpu irq functions as well as adding the Krait l2 indirection
> register code. The next two patches add the driver and the binding and 
> the final patch hooks it all up by adding the device tree node.
> 
> I'm not sure which tree this is supposed to go through. Ideally we could
> send the first 3 plus the 5th one through an edac tree.

Sure, I can take a look at the drivers/edac/ changes but I'd need an ack
for the arch/arm/ stuff before/if I pick it up, i.e. patch 3.

Thanks.
