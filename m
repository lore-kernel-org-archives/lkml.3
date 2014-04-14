Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaDNNmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:42:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:14428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaDNNmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:42:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,857,1389772800"; 
   d="scan'208";a="492591676"
Message-ID: <1397482917.11914.128.camel@smile.fi.intel.com>
Subject: Re: [PATCH v3 6/8] DMA: Freescale: change descriptor release
 process for supporting async_tx
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Apr 2014 16:41:57 +0300
In-Reply-To: <5347A8F2.4050603@freescale.com>
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com>
	 <1397113805-24171-7-git-send-email-hongbo.zhang@freescale.com>
	 <1397131003.11914.108.camel@smile.fi.intel.com>
	 <5347A12F.8040006@freescale.com> <5347A8F2.4050603@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 16:33 +0800, Hongbo Zhang wrote:

> >>> +         * hardware channel, subsequent descriptors are either in
> >>> +         * process or have not been submitted
> >> Dot at the eol. Check in all comments.
> >
> > Even though I saw there are other comments without the dots, I think 
> > it is better to have it.
> > Thanks, all.
> >
> Hmm... think it again, it it really necessary to have it?
> Even I have it in my patch, there are already so many comments exists 
> without it.

For my opinion is better to keep style in your patches. Better if it
commonly used style in the driver. But comment against comments is
really minor thing.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

