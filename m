Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3DVKzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:55:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:63799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3DVKzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:55:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="289703699"
Date: Mon, 22 Apr 2013 15:53:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 21/32] dmaengine: ste_dma40: Also report the number of
 logical channels
Message-ID: <20130422102341.GV24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
 <20130422093631.GE24632@intel.com>
 <20130422101455.GH3432@gmail.com>
 <20130422094842.GL24632@intel.com>
 <20130422103715.GK3432@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422103715.GK3432@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:37:15AM +0100, Lee Jones wrote:
> On Mon, 22 Apr 2013, Vinod Koul wrote:
> You only get a warning for this too:
Yup, oh i wrongly mention error
> 
>  WARNING: quoted string split across lines
> #33: FILE: drivers/dma/ste_dma40.c:3204:
> +	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with "
> +		"%d physical channels and %d logical channels\n",
> 
> > > How would you solve this?
> > Use common sense :) I would never sacrfice readablity of code. Erring on 80chars
> > is fine by me as long as it makes sense.
> 
> Common sense to me says split a string which goes over 100 chars. :)
agreed :)
> 
> ... and I don't think readability is compromised all that much, if at all.
I think if you start above at next line, you can be in 100chars and still be in
single line...
	dev_info(&pdev->dev,
		"hardware revision: %d @ 0x%x with %d physical channels and %d logical channels\n",
Plus a truncated one would help too...
s/revision/rev
s/channels/ch
etc

would bring this to saner levels :)

--
~Vinod
