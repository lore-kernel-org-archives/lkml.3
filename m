Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaJ0V7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:59:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50552 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaJ0V7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:59:14 -0400
Date: Mon, 27 Oct 2014 22:59:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, dinguyen@opensource.altera.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com,
        tthayer@altera.com
Subject: Re: [PATCHv2 0/4] Add Altera peripheral memories to EDAC framework
Message-ID: <20141027215908.GC4741@pd.tnic>
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
 <544E93F0.3030409@opensource.altera.com>
 <20141027204307.GB4741@pd.tnic>
 <544EBA84.7080109@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <544EBA84.7080109@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:35:00PM -0500, Thor Thayer wrote:
> Should I move the EDAC Device probe and error handling from
> altera_edac_mgr.c to altera_edac.c? Can I mix the MC and Device models
> in the same file?

Right, for basic practical reasons, I'd like to keep all functionality
pertaining to one hw flavour in one compilation unit/one driver. We can
always split them later if a compelling reason emerges.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
