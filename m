Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3GXXKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GXXKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:10:51 -0400
Date: Wed, 24 Jul 2013 16:10:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yuan-Hsin Chen <yhchen@faraday-tech.com>
Cc: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com, balbi@ti.com,
        florian@openwrt.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanlmm@gmail.com,
        ratbert.chuang@gmail.com, john453@faraday-tech.com
Subject: Re: [PATCH v2] usb: host: Faraday fotg210-hcd driver
Message-ID: <20130724231050.GA29499@kroah.com>
References: <1370452543-19014-1-git-send-email-yhchen@faraday-tech.com>
 <1371671584-8181-1-git-send-email-yhchen@faraday-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371671584-8181-1-git-send-email-yhchen@faraday-tech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 07:53:04PM +0000, Yuan-Hsin Chen wrote:
> FOTG210 is an OTG controller which can be configured as an
> USB2.0 host. FOTG210 host is an ehci-like controller with
> some differences. First, register layout of FOTG210 is
> incompatible with EHCI. Furthermore, FOTG210 is lack of
> siTDs which means iTDs are used for both HS and FS ISO
> transfer.
> 
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

As your email now is bouncing, I'm going to revert this patch, I can't
take a patch for a driver with no active maintainer, sorry.

If someone else from Faraday will step up and maintain this, that would
be great, please resend it with your email information.

thanks,

greg k-h
