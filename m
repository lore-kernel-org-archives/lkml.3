Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaEEMIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:08:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbaEEMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:08:39 -0400
Date: Mon, 5 May 2014 13:08:35 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: Re: ARC patches for stable 3.10
Message-ID: <20140505120835.GB5869@hercules>
References: <C2D7FE5348E1B147BCA15975FBA230751B1242@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751B1242@IN01WEMBXA.internal.synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 09:53:05AM +0000, Vineet Gupta wrote:
> Hi,
> 
> Please apply the following mainline commits to stable 3.10 as prerequisites for a
> patch for 3.15/stable which will follow to Linus right after.
> 
> 147aece29b15051173eb1e767018135361cdba89  (went in 3.11-rc1)
> "ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption"
> 
> fce16bc35ae4a45634f3dc348d8d297a25c277cf  (went in 3.12-rc1)
> "ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE"
> 
> Thx,
> -Vineet
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you, I'll queue the 2nd patch for the 3.11 kernel (the 1st one
is already applied).

Cheers,
--
Luís
