Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3BCRBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:01:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:20268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab3BCRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:01:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="282235036"
Date: Sun, 3 Feb 2013 18:01:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Provide platform data for MICBIAS
 configuration
Message-ID: <20130203170110.GJ8476@sortiz-mobl>
References: <1359391658-13479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359391658-13479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jan 29, 2013 at 12:47:37AM +0800, Mark Brown wrote:
> Allow the MICBIAS voltages and other attributes to be configured by the
> platform.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c        |   23 +++++++++++++++++++++++
>  include/linux/mfd/arizona/pdata.h |   12 ++++++++++++
>  2 files changed, 35 insertions(+)
Applied as well. After this one, I shouldn't have any pending patches from
you.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
