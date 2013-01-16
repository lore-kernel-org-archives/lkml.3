Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3APG6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:58:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:36568 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab3APG6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:58:11 -0500
Date: Tue, 15 Jan 2013 22:59:05 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Stephen Hurd <shurd@broadcom.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 8250/16?50: Add support for Broadcom TruManage
 redirected serial port
Message-ID: <20130116065905.GA20170@kroah.com>
References: <156984479488CD49A184F5CAB4AF934606FF55F8@IRVEXCHMB14.corp.ad.broadcom.com>
 <20121212044522.GA7224@kroah.com>
 <156984479488CD49A184F5CAB4AF934606FF5627@IRVEXCHMB14.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156984479488CD49A184F5CAB4AF934606FF5627@IRVEXCHMB14.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 05:28:35AM +0000, Stephen Hurd wrote:
> From: Stephen Hurd <shurd@broadcom.com>
> 
> Add support for the UART device present in Broadcom TruManage capable NetXtreme chips (ie: 5761m 5762, and 5725).
> 
> This implementation has a hidden transmit FIFO, so running in single-byte interrupt mode results in too many interrupts.  The UART_CAP_HFIFO capability was added to track this.  It continues to reload the THR as long as the THRE and TSRE bits are set in the LSR up to a specified limit (1024 is used here).
> 
> Signed-off-by: Stephen Hurd <shurd@broadcom.com>
> 
> ---
> 
> Patch against linux-2.7 from ftp.kernel.org downloaded Dec-11-2012.

2.7?

I need this against the linux-next release, can you please redo it, and
not send it as an attachment, but put it all inline in the email
properly like Documentation/email_clients.txt says?

thanks,

greg k-h
