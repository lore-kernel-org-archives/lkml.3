Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbbAGKyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:54:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34451 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbAGKye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:54:34 -0500
Date: Wed, 7 Jan 2015 11:54:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: dougthompson@xmission.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, punnaia@xilinx.com
Subject: Re: [PATCH v8] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20150107105430.GA3984@pd.tnic>
References: <a728a8d4678f4dbf9de189a480297c3d@BY2FFO11FD034.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a728a8d4678f4dbf9de189a480297c3d@BY2FFO11FD034.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:13:47PM +0530, Punnaiah Choudary Kalluri wrote:
> Added EDAC support for reporting the ecc errors of synopsys ddr controller.
> The ddr ecc controller corrects single bit errors and detects double bit
> errors.
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>

Applied and queued for 3.20,
thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
