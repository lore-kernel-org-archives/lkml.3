Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3FRR6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:58:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:37954 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872Ab3FRR6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:58:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,890,1363158000"; 
   d="scan'208";a="318970917"
Date: Tue, 18 Jun 2013 10:58:45 -0700
From: Jubin Mehta <jubin.mehta@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
Message-ID: <20130618175844.GC5054@intel.com>
References: <20130613172408.GA5561@intel.com>
 <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:59:00AM +0300, Andy Shevchenko wrote:
> > +PATH = /sys/kernel/debug/dmatest/cap_mask
> > +(DEFAULT) echo 0x07 > $PATH     // Set Bits 0,1,2 for MEMCPY, XOR and PQ
> > +          echo 0x01 > $PATH     // Set bit 0 to enable MEMCPY
> > +          echo 0x02 > $PATH     // Set bit 1 to enable XOR
> > +          echo 0x04 > $PATH     // Set bit 2 to enable PQ
> 
> What if we make examples  followed by # and comments?
> And move (DEFAULT) to the commentary.
>
Yes, I shall fix the issue in the next patch.
 
Regards,
Jubin 
