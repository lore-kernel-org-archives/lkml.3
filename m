Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaH2QCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:02:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52492 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaH2QCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:02:15 -0400
Date: Fri, 29 Aug 2014 18:02:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: tthayer@opensource.altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        dougthompson@xmission.com, grant.likely@linaro.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com
Subject: Re: [PATCHv10 1/2] edac: altera: Add Altera SDRAM EDAC support.
Message-ID: <20140829160204.GA8835@nazgul.tnic>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
 <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:18:12AM -0500, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> This patch adds support for the CycloneV and ArriaV SDRAM controllers.
> Correction and reporting of SBEs, Panic on DBEs.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
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
> 
> v6: Changes to split out shared SDRAM controller reg (offset 0x00)
>     as a syscon device and allocate ECC specific SDRAM registers
>     to EDAC.
> 
> v7: No changes. Bump for consistency.
> 
> v8: Alphabetize headers.
> 
> v9: Changes to support a MFD SDRAM controller with nested EDAC.
> 
> v10: Revert to version 5 (syscon) and fix errors found in v5.

EDAC bits look ok to me,

Acked-by: Borislav Petkov <bp@suse.de>

Dinh, please convert that version information above to a nice commit
message and add it when applying as it is very useful for future
reference.

Thanks.

-- 
Regards/Gruss,
    Boris.
--
