Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935931Ab3DINCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:02:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:14834 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935797Ab3DINCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="225025556"
Date: Tue, 9 Apr 2013 15:02:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, rogerq@ti.com
Subject: Re: [PATCH Resend 1/2] mfd: omap-usb-host: Convert to
 devm_ioremap_resource()
Message-ID: <20130409130221.GI23447@zurbaran>
References: <1365504397-29867-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365504397-29867-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Tue, Apr 09, 2013 at 04:16:36PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Roger Quadros <rogerq@ti.com>
> ---
> Rebased onto latest mfd-next tree.
> ---
>  drivers/mfd/omap-usb-host.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
Both patches applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
