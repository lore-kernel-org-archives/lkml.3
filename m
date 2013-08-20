Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3HTBnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:43:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:60049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab3HTBng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,916,1367996400"; 
   d="scan'208";a="284108141"
Date: Tue, 20 Aug 2013 03:43:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH] mfd: dbx500: Remove any mention of the BML8580CLK
Message-ID: <20130820014321.GH13324@zurbaran>
References: <1376912313-26512-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376912313-26512-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Aug 19, 2013 at 12:38:33PM +0100, Lee Jones wrote:
> The platform which it pertains to is no longer supported and is actually
> causing some confusion in the new common clock implementation. A recent
> patch removed its use in the clock driver, let's take out the definitions
> too.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
