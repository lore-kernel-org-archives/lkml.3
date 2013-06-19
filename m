Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab3FSCsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:48:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901Ab3FSCr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:47:59 -0400
Date: Tue, 18 Jun 2013 19:48:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chao Xie <chao.xie@marvell.com>
Cc: stern@rowland.harvard.edu, balbi@ti.com, rogerq@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, xiechao.mail@gmail.com
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
Message-ID: <20130619024839.GA1987@kroah.com>
References: <1371609080-30595-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371609080-30595-1-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:31:20PM -0400, Chao Xie wrote:
> Some controller need software to initialize PHY before add
> host controller, and shut down PHY after remove host controller.
> Add the generic code for these controllers so they do not need
> do it in its own host controller driver.

Why?  What breaks if we add this patch, and what gets fixed?  I'm
guessing you can then remove code?

What out-of-tree code now works properly?  Or gets broken?

we need more info here please...

thanks,

greg k-h
