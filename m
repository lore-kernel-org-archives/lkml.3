Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaGDHiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:38:01 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:65296 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbaGDHh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:37:59 -0400
Message-ID: <1404459477.27680.10.camel@x220>
Subject: usb: gadget: net2280: CONFIG_USB_GADGET_PDEBUG_FILES?
From: Paul Bolle <pebolle@tiscali.nl>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 09:37:57 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2014 07:37:57.0902 (UTC) FILETIME=[E00FDAE0:01CF975A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e56e69cc0ff4 ("usb: gadget: net2280: Use pr_* function") is
included in today's linux-next (ie, next-20140704).

It contains this odd chunk:
    @@ -1566,7 +1563,7 @@ static const struct usb_gadget_ops net2280_ops = {
     
     /*-------------------------------------------------------------------------*/
     
    -#ifdef CONFIG_USB_GADGET_DEBUG_FILES
    +#ifdef CONFIG_USB_GADGET_PDEBUG_FILES
     
     /* FIXME move these into procfs, and use seq_file.
      * Sysfs _still_ doesn't behave for arbitrarily sized files,

(Commit b7ca96655ddd ("usb: gadget: Gadget directory cleanup - group UDC
drivers"), also included in today's linux-next, moved that new check for
CONFIG_USB_GADGET_PDEBUG_FILES to drivers/usb/gadget/udc/net2280.c.)

Using CONFIG_USB_GADGET_PDEBUG_FILES appears to be just an editing
mistake. Would Ricardo like to submit the trivial patch to clean it up
or should I do that?


Paul Bolle

