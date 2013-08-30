Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3H3SIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:08:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3H3SIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:08:42 -0400
Date: Fri, 30 Aug 2013 11:11:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Graham Williams <gwilli@broadcom.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: acm gadget: Null termintate strings table
Message-ID: <20130830181107.GA8665@kroah.com>
References: <1377732974-10073-1-git-send-email-gwilli@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377732974-10073-1-git-send-email-gwilli@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 04:36:14PM -0700, Graham Williams wrote:
> The gadget strings table should be null terminated.
> usb_gadget_get_string() loops through the table
> expecting a null at the end of the list.
> 
> Signed-off-by: Graham Williams <gwilli@broadcom.com>

Yeah, this finally worked!  :)

Thanks for sticking with it, much appreciated.  I've now applied this.

greg k-h
