Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3A0XyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:54:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:38582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3A0XyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:54:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="249000570"
Date: Mon, 28 Jan 2013 00:54:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 26/26] mfd: ab8500-gpadc: Use new ab8500_gpadc_get() with
 name parameter
Message-ID: <20130127235405.GU1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-27-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-27-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:56:06PM +0000, Lee Jones wrote:
> From: Philippe Langlais <philippe.langlais@linaro.org>
> 
> The new format of ab8500_gpadc_get() accepts a device name as a
> parameter to specify which device to retrieve. This patch
> enforces the use of that new format.
Where is that new API coming from ? I couldn't find it in the previous 25
patches. If it's there, this one should be merged with the patch that changes
this API.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
