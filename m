Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbaKRPQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:16:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:6197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaKRPPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:15:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609820422"
Date: Tue, 18 Nov 2014 17:14:27 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mfd: dln2: add support for USB-SPI module
Message-ID: <20141118151418.GC2583@lpalcu-linux>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
 <1415799490-27989-3-git-send-email-laurentiu.palcu@intel.com>
 <20141118142816.GE24004@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118142816.GE24004@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Nov 18, 2014 at 02:28:16PM +0000, Lee Jones wrote:
> On Wed, 12 Nov 2014, Laurentiu Palcu wrote:
> 
> > Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
> > Acked-by: Mark Brown <broonie@kernel.org>
> > ---
> >  drivers/mfd/dln2.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> 
> For my own reference:
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> So what's the plan for this set?

I sent a v3 a few hours ago that addresses Johan comments for the 1st
patch. I also included this patch since I didn't find it in mfd next
branches.

laurentiu
