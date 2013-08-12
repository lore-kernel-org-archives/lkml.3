Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3HLMt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:49:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:23275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab3HLMtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:49:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,862,1367996400"; 
   d="scan'208";a="379610401"
Date: Mon, 12 Aug 2013 20:49:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: wangyun@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [fmc] BUG: scheduling while atomic: swapper/0/1/0x00000002
Message-ID: <20130812124918.GA11735@localhost>
References: <52088127.7070109@linux.vnet.ibm.com>
 <20130811135232.GA16878@localhost>
 <20130812124227.GA22310@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812124227.GA22310@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 02:42:27PM +0200, Alessandro Rubini wrote:
> > On 08/11/2013 09:52 PM, Fengguang Wu wrote:
> >> FYI, the bug still exists in the upstream and linux-next kernels.
> 
> Strange. Greg approved the patch I sent. I see it in next-20130809
> but also next-20130801 and other ones with the same hash:
> 
>    783c2fb FMC: fix locking in sample chardev driver

Ah sorry! I checked log and find that the linux-next build failed. So
it's not boot tested at all.

Thanks,
Fengguang

> However, it is not in master.
> 
> It was sent as https://lkml.org/lkml/2013/7/16/196 .
> 
> Greg, can you please put the patch in the bugfix queue?
> 
> Thanks
> /alessandro
