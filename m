Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaHQOUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:20:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaHQOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:20:46 -0400
Date: Sun, 17 Aug 2014 07:18:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: Convert DBG_PRT to pr_<level>
Message-ID: <20140817141820.GA14213@kroah.com>
References: <74a25bc8e53f22901ce926c47d3d8eac37fe1c91.1407740390.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74a25bc8e53f22901ce926c47d3d8eac37fe1c91.1407740390.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:03:18AM -0700, Joe Perches wrote:
> DBG_PRT uses are unnecessarily complex.
> 
> Convert DBG_PRT msglevel to pr_<level>.
> This changes the KERN_<level> type of several uses.
> It also enables dynamic_debug for the pr_debug conversions.
> 
> This patch can be a prelude to converting these pr_<level>
> uses to dev_<level> as appropriate.
> 
> Other changes:
> 
> Realign arguments of these conversions.
> Remove now unused static int msglevel declarations.
> Remove now unused DBG_PRT #define.
> 
> Compile tested only.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Due to patches for this driver sent before this one, that are now in my
staging-next branch of my staging.git tree, this patch doesn't apply :(

Can you refresh it and resend?

thanks,

greg k-h
