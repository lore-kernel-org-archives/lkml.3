Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3HVCyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:54:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3HVCyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:54:37 -0400
Date: Wed, 21 Aug 2013 19:56:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: oliver@neukum.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next V2 2/3] net: huawei_cdc_ncm: Introduce
 the  huawei_cdc_ncm driver
Message-ID: <20130822025629.GA2874@kroah.com>
References: <mrkiko.rs@gmail.com>
 <1377138641-2765-1-git-send-email-mrkiko.rs@gmail.com>
 <1377138641-2765-3-git-send-email-mrkiko.rs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377138641-2765-3-git-send-email-mrkiko.rs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 04:30:40AM +0200, Enrico Mioso wrote:
> This driver supports devices using the NCM protocol as an encapsulation layer
> for other protocols, like the E3131 Huawei 3G modem. This driver was heavily inspired by the qmi_wwan approach & code model.

Line-wrap your changelog lines?

> 
> Suggested-by: Bjorn Mork <bjorn@mork.no>
> Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
> ---
>  drivers/net/usb/Kconfig  |   11 +++++++++++
>  drivers/net/usb/Makefile |    1 +
>  2 files changed, 12 insertions(+)

I think you forgot to add the driver to the patch :(

greg k-h
