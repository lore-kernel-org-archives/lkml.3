Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbaDHPje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:39:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56047 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbaDHPja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:39:30 -0400
Date: Tue, 8 Apr 2014 17:39:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 3/5] devicetree: bindings: Document Krait cache error
 interrupts
Message-ID: <20140408153925.GJ30077@pd.tnic>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
 <1396641450-12854-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396641450-12854-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:57:28PM -0700, Stephen Boyd wrote:
> The Krait L1/L2 error reporting hardware is made up a per-CPU
> interrupt for the L1 cache and a SPI interrupt for the L2.
> 
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/arm/cache.txt | 48 ++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cache.txt b/Documentation/devicetree/bindings/arm/cache.txt
> index b90fcc7c53cf..d7357e777399 100644
> --- a/Documentation/devicetree/bindings/arm/cache.txt
> +++ b/Documentation/devicetree/bindings/arm/cache.txt

Right, that's http://www.spinics.net/lists/arm-kernel/msg308540.html

So whoever picks those patches up, Lorenzo's doc needs to be in his tree
first too.

How about I review the EDAC part and an arm maintainer picks the whole
series up? Would that be easier, logistically?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
