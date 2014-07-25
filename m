Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbaGYGTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:19:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:17729 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaGYGTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="548829991"
Date: Fri, 25 Jul 2014 11:43:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA
 Controller
Message-ID: <20140725061320.GG8181@intel.com>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140724121315.GV20328@lukather>
 <20140724164420.d7c58c9b5f6bf3e06137494f@linux-foundation.org>
 <20140725061130.GF8181@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725061130.GF8181@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:41:30AM +0530, Vinod Koul wrote:
> On Thu, Jul 24, 2014 at 04:44:20PM -0700, Andrew Morton wrote:
> > On Thu, 24 Jul 2014 14:13:15 +0200 Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> > 
> > > On Thu, Jul 17, 2014 at 09:46:14PM +0200, Maxime Ripard wrote:
> > > > Hi,
> > > > 
> > > > This patchset adds support for the DMA controller found in the
> > > > Allwinner A31 and A23 SoCs.
> > > > 
> > > > This has been tested using the newly introduced SPI driver on an A31
> > > > EVK. Support for DMA-driven SPI transfers will be the subject of
> > > > another patch serie.
> > > > 
> > > > This has been around for around 5 monthes now, and didn't get any
> > > > review but nitpicks for three versions, so I feel like it could be
> > > > merged quite quickly.
> > > 
> > > Ok, so, who should I bribe to get this merged?
> > 
> > Turns out I'm easily bribed.  The code looks pretty clean and simple
> > and is refreshingly free of comments, which only confuse people anyway.
> Sorry for the delay, I will get this done today and merge to slave-dmaengine
> next
And looks like Andrew merged them. Do you mind if I take these up thru
dmaengine tree?

-- 
~Vinod
