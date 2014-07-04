Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaGDJ2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:28:05 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54570 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGDJ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <1404459477.27680.10.camel@x220>
References: <1404459477.27680.10.camel@x220>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 4 Jul 2014 11:27:42 +0200
Message-ID: <CAPybu_3WMWDiVrvLKfOyyw7nSfXi9O82JcXKprZq24j05BxDWQ@mail.gmail.com>
Subject: Re: usb: gadget: net2280: CONFIG_USB_GADGET_PDEBUG_FILES?
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My fault. Thank you very much for reporting it. I have just posted the patch


Regards

On Fri, Jul 4, 2014 at 9:37 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Commit e56e69cc0ff4 ("usb: gadget: net2280: Use pr_* function") is
> included in today's linux-next (ie, next-20140704).
>
> It contains this odd chunk:
>     @@ -1566,7 +1563,7 @@ static const struct usb_gadget_ops net2280_ops = {
>
>      /*-------------------------------------------------------------------------*/
>
>     -#ifdef CONFIG_USB_GADGET_DEBUG_FILES
>     +#ifdef CONFIG_USB_GADGET_PDEBUG_FILES
>
>      /* FIXME move these into procfs, and use seq_file.
>       * Sysfs _still_ doesn't behave for arbitrarily sized files,
>
> (Commit b7ca96655ddd ("usb: gadget: Gadget directory cleanup - group UDC
> drivers"), also included in today's linux-next, moved that new check for
> CONFIG_USB_GADGET_PDEBUG_FILES to drivers/usb/gadget/udc/net2280.c.)
>
> Using CONFIG_USB_GADGET_PDEBUG_FILES appears to be just an editing
> mistake. Would Ricardo like to submit the trivial patch to clean it up
> or should I do that?
>
>
> Paul Bolle
>



-- 
Ricardo Ribalda
