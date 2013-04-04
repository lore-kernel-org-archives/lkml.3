Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3DDKGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:06:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40599 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab3DDKGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:06:15 -0400
Message-ID: <515D5094.5080906@ti.com>
Date: Thu, 4 Apr 2013 13:06:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] mfd: omap-usb-tll: Convert to devm_ioremap_resource()
References: <1365068715-15868-1-git-send-email-sachin.kamat@linaro.org> <1365068715-15868-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1365068715-15868-2-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 12:45 PM, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-tll.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
Acked-by: Roger Quadros <rogerq@ti.com>

