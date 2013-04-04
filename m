Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab3DDJiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:38:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:25602 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069Ab3DDJiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:38:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,407,1363158000"; 
   d="scan'208";a="280676335"
Date: Thu, 4 Apr 2013 11:38:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Kyle Manna <kyle@kylemanna.com>
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in
 twl4030_madc_conversion
Message-ID: <20130404093847.GC17363@zurbaran>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
 <201303022323.06091@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303022323.06091@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Sat, Mar 02, 2013 at 11:23:05PM +0100, Pali Rohár wrote:
> On Friday 15 February 2013 23:56:49 Pali Rohár wrote:
> > Driver twl4030-madc has hardcoded channel types (10 - battery
> > current, 1 - battery temperature) and also conversation data
> > in variable twl4030_divider_ratios. These hardcoded channels
> > are incorrect for Nokia RX-51 board (where is channel 0 -
> > battery temperature).
> > 
> > For Nokia RX-51 there is rx51_battery power_supply driver
> > which reporting battery information via
> > twl4030_madc_conversion. But this driver needs raw values
> > (not converted via some hardcoded functions). So this patch
> > adding new parameter "raw" to struct twl4030_madc_request
> > which tell twl4030-madc driver to not convert values, but
> > rather return raw.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> >  drivers/mfd/twl4030-madc.c       |   14 ++++++++++----
> >  include/linux/i2c/twl4030-madc.h |    2 ++
> >  2 files changed, 12 insertions(+), 4 deletions(-)
> > 
> 
> Hello, can somebody review this twl4030-madc patch?
I'll look at all my pending MFD patches starting from tomorrow.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
