Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaBRP1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:27:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaBRP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:27:20 -0500
Date: Tue, 18 Feb 2014 07:29:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: airlied@linux.ie, robdclark@gmail.com, daniel.vetter@ffwll.ch,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: ti: lcdc: Fixed an error check in the clock
 initialization
Message-ID: <20140218152948.GA4555@kroah.com>
References: <1392728215-8521-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392728215-8521-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:56:55PM +0100, Jean-Jacques Hiblot wrote:
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
> Hi,
> 
> this is a simple patch to fix a copy/paste error in the init code of the driver.
> The problem is also present in the v3.10 stable tree
> cheers,
> 
> Jean-Jacques
> 
> drivers/gpu/drm/tilcdc/tilcdc_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
