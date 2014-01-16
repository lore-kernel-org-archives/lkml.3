Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaAPKnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:43:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:2864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaAPKnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:43:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="439745820"
Message-ID: <1389869013.1871.344.camel@smile>
Subject: Re: [PATCH 1/2] Documentation: move all DMA documentations into
 Documentaion/dma
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: hongbo.zhang@freescale.com
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, sumit.semwal@linaro.org,
        Vinod Koul <vinod.koul@intel.com>, Pierre Ossman <drzeus@drzeus.cx>
Date: Thu, 16 Jan 2014 12:43:33 +0200
In-Reply-To: <1389868664-10202-1-git-send-email-hongbo.zhang@freescale.com>
References: <1389868664-10202-1-git-send-email-hongbo.zhang@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 18:37 +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Since there are already seven DMA documentations under the top Documentation/,
> it is better to create one dedicated directory for them.
> 

Can you rebuild this with -M -C and resend?

P.S. hint for future is to use -M -C when you rename files.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

