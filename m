Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937492Ab3DIKNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:13:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:18370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935743Ab3DIKNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="316498843"
Date: Tue, 9 Apr 2013 12:13:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 1/2] mfd: omap-usb-host: Convert to
 devm_ioremap_resource()
Message-ID: <20130409101343.GT24058@zurbaran>
References: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Thu, Apr 04, 2013 at 03:15:14PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
The 2 patches make sense to me, but they don't apply cleanly on top of
mfd-next. Would you mind sending me a rebased version ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
