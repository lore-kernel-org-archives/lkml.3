Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaEDBNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:13:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaEDBNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:13:05 -0400
Date: Sat, 3 May 2014 20:20:09 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8723au: Remove unused pointer in
 rtw_wdev_free()
Message-ID: <20140504002009.GA26063@kroah.com>
References: <20140426221029.33a59eff@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426221029.33a59eff@spike>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:10:29PM +0200, Christian Engelmayer wrote:
> Pointer 'pwdev_priv' in function rtw_wdev_free() is unused - thus remove it.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against v3.15-rc2 as well as branch staging-next
> of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

This doesn't seem to apply to my tree at all :(

greg k-h
