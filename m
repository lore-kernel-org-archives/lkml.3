Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbaDHKI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:08:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaDHKIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:08:55 -0400
Date: Tue, 8 Apr 2014 12:08:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: tthayer@altera.com
Cc: robherring2@gmail.com, dougthompson@xmission.com, grant.likely@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com,
        devicetree@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
Message-ID: <20140408100851.GF30077@pd.tnic>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
 <1396907649-20212-4-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396907649-20212-4-git-send-email-tthayer@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 04:54:09PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Added EDAC support for reporting ECC errors of CycloneV
> and ArriaV SDRAM controller.
> - The SDRAM Controller registers are used by the FPGA bridge so
>   these are accessed through the syscon interface.
> - The configuration of the SDRAM memory size for the EDAC framework
>   is discovered from the memory node of the device tree.
> - Documentation of the bindings in devicetree/bindings/arm/altera/
>   socfpga-sdram-edac.txt
> - Correction of single bit errors, detection of double bit errors.

Before I go and take a look at this further, is anyone at Altera going
to maintain this driver in case of bug reports and issues with it?

Also, I see patch 3/3. Are the other two related? I see they are
devicetree additions and, as such, all three should go together...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
