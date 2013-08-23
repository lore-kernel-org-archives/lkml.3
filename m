Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3HWRth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:49:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3HWRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:49:36 -0400
Date: Fri, 23 Aug 2013 10:49:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Graham Williams <gwilli@broadcom.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [PATCH] usb: acm gadget: Null termintate strings table
Message-ID: <20130823174935.GA3409@kroah.com>
References: <063828A851006E448B735F1021E028962ACE7245@SJEXCHMB09.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063828A851006E448B735F1021E028962ACE7245@SJEXCHMB09.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:43:51PM +0000, Graham Williams wrote:
> 
> The gadget strings table should be null terminated.
> usb_gadget_get_string() loops through the table
> expecting a null at the end of the list.
> 
> Signed-off-by: Graham Williams<gwilli@broadcom.com>

Minor nit, you need a space after your last name and before the '<'.

Third time's a charm?
