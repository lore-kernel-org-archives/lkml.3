Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3CZUhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:37:45 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56657 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3CZUhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:37:43 -0400
Date: Tue, 26 Mar 2013 13:37:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
Message-ID: <20130326203741.GA4227@kroah.com>
References: <1364319361-28265-1-git-send-email-stigge@antcom.de>
 <20130326180334.GL20785@arwen.pp.htv.fi>
 <5151F48C.9060308@gnu.org>
 <20130326192453.GA21915@arwen.pp.htv.fi>
 <5152043F.4010307@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5152043F.4010307@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 09:25:35PM +0100, Roland Stigge wrote:
> On 03/26/2013 08:24 PM, Felipe Balbi wrote:
> > commit ?
> 
> 1c2088812f095df77f4b3224b65db79d7111a300

Showed up in 3.9-rc3.

Felipe, I can take this directly if you don't have any other USB patches
for me at the moment.

greg k-h
