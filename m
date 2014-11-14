Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511AbaKNMdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:33:08 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55184 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965171AbaKNMdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:33:06 -0500
Date: Fri, 14 Nov 2014 12:33:01 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] DMA: Fix allocation size for PL330 data buffer depth.
Message-ID: <20141114123301.GK12037@e106497-lin.cambridge.arm.com>
References: <1415294412-13818-1-git-send-email-Liviu.Dudau@arm.com>
 <20141112093952.GD24582@intel.com>
MIME-Version: 1.0
In-Reply-To: <20141112093952.GD24582@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 14 Nov 2014 12:33:02.0644 (UTC) FILETIME=[21D9D740:01D00007]
X-MC-Unique: 114111412330307901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 09:39:52AM +0000, Vinod Koul wrote:
> On Thu, Nov 06, 2014 at 05:20:12PM +0000, Liviu Dudau wrote:
> > The datasheet for PL330 says that the data buffer value in the CRD
> > register is 10bits wide. However, the value stored is "minus one",
> > which the driver corrects for. Maximum value that the data buffer
> > depth can have is 1024 lines, which requires 11 bits for storage.
> > 
> > While making updates I found printing the peripheral ID as a hex
> > value to be more useful as the datasheet shows the values that way.
> 
> Applied, thanks

Thanks!

> 
> Please snure you use the right subsytem name

Sorry about that. Just for clarity, it should've been 'dmaengine', right?

Best regards,
Liviu

> 
> -- 
> ~Vinod
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

