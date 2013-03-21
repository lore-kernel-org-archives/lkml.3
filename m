Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3CUKgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:36:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:23515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab3CUKgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:36:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="217294407"
Date: Thu, 21 Mar 2013 15:40:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: request line field in the generic slave config structure
Message-ID: <20130321101059.GQ10326@intel.com>
References: <1363612546.18714.85.camel@smile>
 <201303181330.29328.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303181330.29328.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 01:30:29PM +0000, Arnd Bergmann wrote:
> On Monday 18 March 2013, Shevchenko, Andriy wrote:
> > Hello!
> > 
> > It seems the one (as I think good) question was left unanswered:
> > http://www.spinics.net/lists/arm-kernel/msg186120.html
> > 
> > What is your opinions, comments?
> 
> I'm not sure I understand what the question was. Is this about
> whether we should remove the "slave_id" field in the slave
> configuration?
Ditto :)

The slave_id memeber in dma_slave_config should be used for this

> 
> Those sort of duplicate the request line information that comes
> from the platform in a data structure that should be filled by
> the device driver without platform specific knowledge.
> 
> I believe that is currently used by shmobile, and we won't be able
> to kill that before that platform has been converted to use
> dma_request_slave_channel.
> 
> 	Arnd
