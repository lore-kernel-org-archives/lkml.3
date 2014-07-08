Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaGHBkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:40:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaGHBkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:40:43 -0400
Date: Mon, 7 Jul 2014 18:45:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] phy: core: Fix error path in phy_create()
Message-ID: <20140708014506.GC13844@kroah.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
 <1404715705-5041-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404715705-5041-6-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 12:18:22PM +0530, Kishon Vijay Abraham I wrote:
> From: Roger Quadros <rogerq@ti.com>
> 
> Prevent resources from being freed twice in case device_add() call
> fails within phy_create(). Also use ida_simple_remove() instead of
> ida_remove() as we had used ida_simple_get() to allocate the ida.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-core.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Is this a problem in older kernels as well?

thanks,

greg k-h
