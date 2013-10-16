Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934Ab3JPOLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:11:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563Ab3JPOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:11:45 -0400
Date: Wed, 16 Oct 2013 07:12:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Youquan Song <youquan.song@linux.jf.intel.com>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Message-ID: <20131016141247.GB17567@kroah.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
 <20131011133343.GB32689@kroah.com>
 <20131013152633.GM2954@intel.com>
 <20131015183142.GA12494@linux-youquan.bj.intel.com>
 <CAPcyv4jJSgM7EmDMW-rcjVCnC6-95+qeU9yf+yxD-wMCcQ8amg@mail.gmail.com>
 <20131016053857.GV2954@intel.com>
 <1381912571.29062.135.camel@smile>
 <20131016075702.GW2954@intel.com>
 <1381914782.29062.137.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381914782.29062.137.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:13:20AM +0000, Shevchenko, Andriy wrote:
> On Wed, 2013-10-16 at 13:27 +0530, Vinod Koul wrote:
> > On Wed, Oct 16, 2013 at 02:06:30PM +0530, Shevchenko, Andriy wrote:
> > > On Wed, 2013-10-16 at 11:08 +0530, Vinod Koul wrote:
> 
> []
> 
> > > > Well am going to take it a bit further and ask you why do we need the
> > > > /sys/class/dma? I have never used it for slave work.
> > > 
> > > How user (who, f.e., would like to run dmatest) will know names of the
> > > channels provided?
> > Ok dmatest requires this, I overlooked that part
> > 
> > > How could we see what channels of certain dma controller are requested /
> > > busy from userspace?
> > But do end user care or need to know about this?
> 
> The idea is to have some test cases. So, end user probably doesn't
> really need this.

So could this just be debugfs files instead?
