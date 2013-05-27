Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3E0KHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:07:04 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:58494 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3E0KHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:07:02 -0400
Message-ID: <51A3300A.2060403@synopsys.com>
Date: Mon, 27 May 2013 15:36:02 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.documentation,gmane.linux.drivers.devicetree,gmane.linux.kernel
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] irqchip: Add TB10x interrupt controller driver
References: <1365686252-9828-1-git-send-email-christian.ruppert@abilis.com> <1367930258-27056-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1367930258-27056-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.192]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 06:07 PM, Christian Ruppert wrote:
> The SOC interrupt controller driver for the Abilis Systems TB10x series of
> SOCs based on ARC700 CPUs.
> 
> This driver is required to boot the arch/arc/plat-tb10x platform already
> present in linux-next. Please consider this patch for inclusion in 3.10.
> This is the rebase of a previous version on linux-next.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Looks good to me !

Reviewed-by: Vineet Gupta <vgupta@synopsys.com>

P.S. @tglx can you please review this at your earliest convenience and provide any
feedback to Chrisitian. This driver is essential to their platform and it would be
nice to have it in mainline in 3.11

Thx,
-Vineet
