Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab3AXVc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:32:29 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45084 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945933Ab3AXVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:32:17 -0500
Date: Thu, 24 Jan 2013 13:32:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH v2 2/2] usb: dwc3-exynos: Fix compatible strings for the
 device
Message-ID: <20130124213213.GA21329@kroah.com>
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
 <1359035130-22667-3-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359035130-22667-3-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 07:15:30PM +0530, Vivek Gautam wrote:
> Using specific chip in compatible strings. Newer SOCs can claim
> device by using older string in the compatible list.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Felipe, want me to take this one, or will you?

thanks,

greg k-h
