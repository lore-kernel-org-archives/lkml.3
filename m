Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbaJ3PWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:22:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36944 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118AbaJ3PWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:22:47 -0400
Date: Thu, 30 Oct 2014 16:22:40 +0100
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
Message-ID: <20141030152240.GD11178@pd.tnic>
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
 <544E93F0.3030409@opensource.altera.com>
 <20141027204307.GB4741@pd.tnic>
 <544EBA84.7080109@opensource.altera.com>
 <20141027215908.GC4741@pd.tnic>
 <544ECBB1.2040600@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <544ECBB1.2040600@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 05:48:17PM -0500, Thor Thayer wrote:
> Would the L2 cache and OCRAM specific functions also be in altera_edac.c?
> Each of these EDAC pieces is independent and can be compiled in without the
> others. I've read that the use of #ifdef's is discouraged and having
> separate files in the Makefile solves that.

Let's keep it simple and put all the altera bits in one file for now. If
we need to split some of the functionality out, we can always do that
later.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
