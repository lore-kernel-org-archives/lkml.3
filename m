Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaEGB1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 21:27:03 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53434 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267AbaEGB1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 21:27:00 -0400
X-Sasl-enc: Fqw8EnIiJgYJqHzr4Ytjr91lazpVbxSz5IyldAfMX5ls 1399426019
Date: Tue, 6 May 2014 15:44:56 -0700
From: Greg KH <greg@kroah.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: Re: ARC patches for stable 3.10
Message-ID: <20140506224456.GD4185@kroah.com>
References: <C2D7FE5348E1B147BCA15975FBA230751B1242@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751B1242@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

Now applied, thanks.

greg k-h
