Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937083Ab3DIIUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:20:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:62773 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936058Ab3DIIUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="224937988"
Date: Tue, 9 Apr 2013 10:20:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] mfd: ab8500-core: Ignore masked out interrupts
Message-ID: <20130409082046.GK24058@zurbaran>
References: <1363873784-27378-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363873784-27378-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Thu, Mar 21, 2013 at 02:49:44PM +0100, Fabio Baltieri wrote:
> AB8500 asserts LATCH bits for masked out interrupts.  This patch
> explicitly masks those out using the cached mask value to prevent
> handle_nested_irq() being called for masked IRQ on the same register as
> unmasked ones.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
> 
> Hello Samuel, Anton,
> 
> this is a small fix for the AB8500 irq generation code.  As this depends
> on Lee's patches already merged in the battery tree, this patch is based
> on Anton's repository, and should apply cleanly on it and on next.
As Lee prepared a branch for Anton and me to pull from, this patch applied
cleanly on top of mfd-next. So I took it and pushed it now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
