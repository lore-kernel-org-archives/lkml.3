Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbaJ2X2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:28:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaJ2X2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:28:50 -0400
Date: Wed, 29 Oct 2014 16:27:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: micky_ching@realsil.com.cn, dan.carpenter@oracle.com, joe@perches.com,
        giedrius.statkevicius@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Staging: rts5208: rtsx_reset_chip style clean up
Message-ID: <20141029232740.GA4063@kroah.com>
References: <1414619899-2633-1-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414619899-2633-1-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:58:17PM +0100, Fabio Falzoi wrote:
> Clean up the code in rtsx_reset_chip function defining two new helper
> functions rtsx_reset_aspm and rtsx_enable_pcie_intr.
> Specifically, the following checkpatch warnings are corrected:
> 
> * PARENTHESIS_ALIGNMENT at rows 295 and 313
> 
> This patch is inspired by the following post on LKML regarding another
> clean up for rts5208 module:
> http://www.spinics.net/lists/linux-driver-devel/msg55038.html
> 
> Changes in v3:
> * rebased against master branch of linux-next tree

That's not going to work, can you redo it against my staging-testing
branch of staging.git?  Or, if you really want to work off of
linux-next, wait a few days before I merge my staging-testing branch
into staging-next to show up in linux-next.

As it is, these patches don't apply, so I'm going to have to drop them
from my queue.

thanks,

greg k-h
