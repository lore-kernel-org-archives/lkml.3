Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3JMQTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:19:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:25541 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab3JMQTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,486,1378882800"; 
   d="scan'208";a="307248542"
Date: Sun, 13 Oct 2013 20:56:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Youquan Song <youquan.song@intel.com>, dan.j.williams@intel.com,
        andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.jf.intel.com>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Message-ID: <20131013152633.GM2954@intel.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
 <20131011133343.GB32689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011133343.GB32689@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 06:33:43AM -0700, Greg KH wrote:
> On Fri, Oct 11, 2013 at 05:42:17PM -0400, Youquan Song wrote:
> > Currently, the DMA channel calculates its data transferred only at network
> > device driver. When other devices like UART or SPI etc, transfers data by DMA 
> > mode, but it always shows 0 at /sys/class/dma/dma0chan*/bytes_transferred.
> 
> Is that really a problem?  I have never heard anyone complaining about
> it.  Where are the reports of this?
Right, am not still getting the point on what is the problem that this series is
trying to fix..

~Vinod
