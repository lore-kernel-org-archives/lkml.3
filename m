Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab3E0PCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:02:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:57429 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab3E0PCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:02:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,751,1363158000"; 
   d="scan'208";a="247259925"
Date: Mon, 27 May 2013 19:55:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>, Dan Williams <djbw@fb.com>,
        Rabin Vincent <rabin@rab.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: ste_dma40: fix pm runtime ref counting
Message-ID: <20130527142523.GD30200@intel.com>
References: <1369663420-3881-1-git-send-email-rabin.vincent@stericsson.com>
 <CACRpkdbHYeU3wgNkVtGEeuLUUKjFHZkdz01vpObgN4KVO8BvVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbHYeU3wgNkVtGEeuLUUKjFHZkdz01vpObgN4KVO8BvVw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 04:05:57PM +0200, Linus Walleij wrote:
> On Mon, May 27, 2013 at 4:03 PM, Rabin Vincent
> <rabin.vincent@stericsson.com> wrote:
> 
> > The pm runtime reference counting of the driver is broken for the case
> > when there is more than one transfer queued, leading to the device being
> > runtime suspend while active.  Fix it.
> >
> > Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> Looks good to me.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Vinod, are you taking this for fixes?
Sure, applied to fixes. CCed stable as well

--
~Vinod
