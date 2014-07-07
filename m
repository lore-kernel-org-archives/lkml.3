Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaGGIWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:22:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56883 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaGGIWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:22:49 -0400
Date: Mon, 7 Jul 2014 09:22:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Cooper <jason@lakedaemon.net>, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: linux-next: manual merge of the mvebu tree with the arm tree
Message-ID: <20140707082236.GX21766@n2100.arm.linux.org.uk>
References: <20140707112853.7f5a9323@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707112853.7f5a9323@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 11:28:53AM +1000, Stephen Rothwell wrote:
> diff --cc arch/arm/mach-mvebu/headsmp-a9.S
> index 7c91ddb6f1f7,da5bb292b91c..000000000000
> --- a/arch/arm/mach-mvebu/headsmp-a9.S
> +++ b/arch/arm/mach-mvebu/headsmp-a9.S
> @@@ -14,8 -14,9 +14,10 @@@
>   
>   #include <linux/linkage.h>
>   #include <linux/init.h>
>  +#include <asm/assembler.h>
>   
> + #include <asm/assembler.h>
> + 

Obviously not quite correct - this looks like an automatic merge, something
that will have to be kept an eye on during the proper merge window.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
