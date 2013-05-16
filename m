Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3EPWN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:13:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:34988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab3EPWNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:13:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338561516"
Date: Fri, 17 May 2013 00:13:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: jz4740-adc: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20130516221353.GJ22822@zurbaran>
References: <1368381948-4050-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368381948-4050-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Sun, May 12, 2013 at 08:05:48PM +0200, Lars-Peter Clausen wrote:
> In preparation to switching the jz4740 clk driver to the common clk framework
> update the clk enable/disable calls to clk_prepare_enable/clk_disable_unprepare.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/mfd/jz4740-adc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied to my mfd-next tree, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
