Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaIKHF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:05:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:12474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaIKHFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384583716"
Date: Thu, 11 Sep 2014 12:12:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mark Brown <broonie@kernel.org>, Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Alan Cox <alan@linux.jf.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/12] dmaengine: dw: remove slave_id, add PCI
 support
Message-ID: <20140911064212.GI3131@intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:29:11PM +0300, Andy Shevchenko wrote:
> The patchset is targeting two things:
>  - removal of slave_id which is deprecated (suggested by Arnd Bergmann)
>  - support BayTrail and Braswell SoCs in PCI case
> 
> They are tight with each other, thus comes in one series.
> 
> The patch set was BAT tested on Braswell and BayTrail machines.
> 
> We would like to push this through slave-dma tree, so, Mark, Greg,
> Hans-Christian, and Haavard, please, Ack them if you have no objections.
> 
> Vinod, we would like them to be pushed during this cycle since we have more
> coming. And it would be nice to have Braswell support in v3.18-rc1.

Applied all except the three SPI patches. One of them Mark has applied, rest
dont apply for me, so pls resend with acks.

-- 
~Vinod
