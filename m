Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab3H2UFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:05:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab3H2UFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:05:23 -0400
Date: Thu, 29 Aug 2013 13:07:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] radeon kms: fix uninitialised hotplug work usage in
 r100_irq_process()
Message-ID: <20130829200746.GA13366@kroah.com>
References: <alpine.SOC.1.00.1307310017380.19288@math.ut.ee>
 <alpine.SOC.1.00.1308191158220.19642@math.ut.ee>
 <alpine.SOC.1.00.1308291017030.2723@math.ut.ee>
 <20130829092935.GB2235@swordfish>
 <alpine.SOC.1.00.1308291250350.2723@math.ut.ee>
 <CADnq5_OPQD68o80ZGZODOxR3V2M7dU1xEYEhqjDKPcqgGwWYeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_OPQD68o80ZGZODOxR3V2M7dU1xEYEhqjDKPcqgGwWYeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 02:27:52PM -0400, Alex Deucher wrote:
> On Thu, Aug 29, 2013 at 6:55 AM, Meelis Roos <mroos@linux.ee> wrote:
> >> Reported-by: Meelis Roos <mroos@linux.ee>
> >> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >
> > It works, thank you for quick response!
> >
> > Tested-by: Meelis Roos <mroos@linux.ee>
> 
> Thanks.  I've added it to my patch queue.

Can you add a cc: stable mark if it also is going to affect the stable
kernels as well?

thanks,

greg k-h
