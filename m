Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3HWXg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:36:26 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49996 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517Ab3HWXgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:36:25 -0400
X-Sasl-enc: 4AnFDDrgt2JjDf7lDOgZ3pcBP/26Y/musDiLfKhFq9Bh 1377300984
Date: Fri, 23 Aug 2013 16:36:23 -0700
From: Greg KH <greg@kroah.com>
To: Graham Williams <gwilli@broadcom.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [PATCH] usb: acm gadget: Null termintate strings table
Message-ID: <20130823233623.GA2832@kroah.com>
References: <063828A851006E448B735F1021E028962ACE7736@SJEXCHMB09.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063828A851006E448B735F1021E028962ACE7736@SJEXCHMB09.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 11:19:55PM +0000, Graham Williams wrote:
> I couldn't get the whitespace formatting correctly from Windows Office (work email) so I attached the patch file.  I ran it on it applies correctly.


I can't take attachments, and especially not base64 ones :(

Take a look at the file I pointed you at in the Documentation directory
for how to set up other email clients to work.  Lots of other Broadcom
developers have this working properly for their work emails, so perhaps
you should contact them and ask what the magic incantantation is.

thanks,

greg k-h
