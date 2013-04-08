Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab3DHOer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:34:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:34334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964883Ab3DHOeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:34:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="315983360"
Date: Mon, 8 Apr 2013 16:34:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in
 twl4030_madc_conversion
Message-ID: <20130408143433.GC21256@zurbaran>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Fri, Feb 15, 2013 at 11:56:49PM +0100, Pali Rohár wrote:
> Driver twl4030-madc has hardcoded channel types (10 - battery current,
> 1 - battery temperature) and also conversation data in variable
> twl4030_divider_ratios. These hardcoded channels are incorrect for
> Nokia RX-51 board (where is channel 0 - battery temperature).
> 
> For Nokia RX-51 there is rx51_battery power_supply driver which reporting
> battery information via twl4030_madc_conversion. But this driver needs
> raw values (not converted via some hardcoded functions). So this patch
> adding new parameter "raw" to struct twl4030_madc_request which tell
> twl4030-madc driver to not convert values, but rather return raw.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/mfd/twl4030-madc.c       |   14 ++++++++++----
>  include/linux/i2c/twl4030-madc.h |    2 ++
>  2 files changed, 12 insertions(+), 4 deletions(-)
I appled this patch and the power one to my mfd-next tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
