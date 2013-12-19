Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3LSGfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:35:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3LSGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:35:23 -0500
Date: Wed, 18 Dec 2013 22:35:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Huang Rui <ray.huang@amd.com>, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: usbtest: Always clear halt else further tests
 will fail
Message-ID: <20131219063525.GB18820@kroah.com>
References: <1387361411-15139-1-git-send-email-rogerq@ti.com>
 <1387361411-15139-2-git-send-email-rogerq@ti.com>
 <20131219040146.GC19091@hr-dev.amd.com>
 <20131219054651.GD19091@hr-dev.amd.com>
 <52B29079.2040704@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B29079.2040704@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:51:45AM +0530, Roger Quadros wrote:
> On 12/19/2013 11:16 AM, Huang Rui wrote:
> > On Thu, Dec 19, 2013 at 12:01:47PM +0800, Huang Rui wrote:
> >> On Wed, Dec 18, 2013 at 03:40:11PM +0530, Roger Quadros wrote:
> >>> In test_halt() we set an endpoint halt condition and return on halt verification
> >>> failure, then the enpoint will remain halted and all further tests related
> >                       ^^^^^^^
> >>> to that enpoint will fail. This is because we don't tackle endpoint halt error condition
> >             ^^^^^^^
> > BTW, please fix these typo.
> 
> Hi Rui,
> 
> These patches have been already applied to Greg's usb tree without your Ack's or the typo fix.
> 
> Greg,
> 
> do you want me to resend the patches?

Nope, it's not a big deal, typo's in changelog comments isn't a worry.

greg k-h
