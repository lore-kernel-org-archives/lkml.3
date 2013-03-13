Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab3CMIiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:38:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:51075 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab3CMIis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:38:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,834,1355126400"; 
   d="scan'208";a="300780151"
Date: Wed, 13 Mar 2013 09:38:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-audio: Fix argument type for
 twl4030_audio_disable_resource()
Message-ID: <20130313083841.GG21994@zurbaran>
References: <1362209435-11029-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362209435-11029-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 03:30:35PM +0800, Mark Brown wrote:
> Looks like the conversion to enum was missed for the definition of this
> function, the declaration has been updated.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/twl4030-audio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to my mfd-fixes tree, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
