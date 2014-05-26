Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaEZJ5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:57:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52840 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaEZJ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:57:41 -0400
Date: Mon, 26 May 2014 11:57:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv5 3/3] edac: altera: Add EDAC support for Altera SoC
 SDRAM Controller
Message-ID: <20140526095730.GC25732@pd.tnic>
References: <1400169891-29546-1-git-send-email-tthayer@altera.com>
 <1400169891-29546-4-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400169891-29546-4-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:04:51AM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> v2: Use the SDRAM controller registers to calculate memory size
>     instead of the Device Tree. Update To & Cc list. Add maintainer
>     information.
> 
> v3: EDAC driver cleanup based on comments from Mailing list.
> 
> v4: Panic on DBE. Add macro around inject-error reads to prevent
>     them from being optimized out. Remove of_match_ptr since this
>     will always use Device Tree.
> 
> v5: Addition of printk to trigger function to ensure read vars
>     are not optimized out.

Yeah, you could turn those vX: messages into a real commit message -
much better than none at all :-)

Other than that, the edac bits look ok. I'll wait out until you guys've
sorted the devicetree issues so ping me when it is ready to pick up.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
