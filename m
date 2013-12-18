Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3LRRco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:32:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:26205 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab3LRRcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:32:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="426739881"
Date: Wed, 18 Dec 2013 22:03:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Message-ID: <20131218163336.GO16227@intel.com>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
 <20131128055706.GM8834@intel.com>
 <20131209235035.GA11632@n2100.arm.linux.org.uk>
 <20131210101331.GG29580@intel.com>
 <20131210111449.GY4360@n2100.arm.linux.org.uk>
 <CAPcyv4gAazGS_m6KNfF2_kY3CDzYkvpBQ=kcnPH-pBvcJ0HjAw@mail.gmail.com>
 <CAPcyv4iNOqHSQXj_PTmG-iHajnmHoPhLeFvnnK-JtNykf2W3Ew@mail.gmail.com>
 <20131218154045.GC16227@intel.com>
 <CAPcyv4hiGg6J0sAEy6N=HRsLg_B9PGOc=khaTNR80==pDfNQzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hiGg6J0sAEy6N=HRsLg_B9PGOc=khaTNR80==pDfNQzQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 08:55:23AM -0800, Dan Williams wrote:
> >> > Vinod, if your fixes branch is ready I'll take it along with the rest
> >> > of the regression fixes to Linus.
> > Sorry I wasnt well last week, so I just managed to send the PULL on friday
> > morning. Wasnt sure if Linus will cut rc on friday or later, so sent it!
> 
> Ok, glad you are feeling better.
Thanks

> 
> >>
> >> Ok, I see you sent dma-slave/fixes up, I'll follow up with the rest:
> > Okay, did you manage to send it? If not I may have few (i think at least 1 more)
> >
> 
> Patchwork id(s)?  I want to send it it today.

3266451, I have acked it!

--
~Vinod

-- 
