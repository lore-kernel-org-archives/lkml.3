Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3K2M4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:56:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:47106 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab3K2M43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:56:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,797,1378882800"; 
   d="scan'208";a="444124866"
Message-ID: <1385729760.1871.23.camel@smile>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org
Date: Fri, 29 Nov 2013 14:56:00 +0200
In-Reply-To: <1385663555.12210.19.camel@joe-AO722>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1385663555.12210.19.camel@joe-AO722>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 10:32 -0800, Joe Perches wrote:
> On Thu, 2013-11-28 at 13:28 +0200, user.email wrote:
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > Add the %paD format specifier for printing a dma_addr_t type, since the
> > DMA address size on some platforms can vary based on build options,
> > regardless of the native integer type.
> 
> OK, but I prefer this one because upper case is
> sometimes used to specify upper case only output.
> ala %x %X and %pUl %pUL.

No objections.

> https://lkml.org/lkml/2013/9/12/483

Hmm... Still not in kernel. Do you know reason why it so?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

