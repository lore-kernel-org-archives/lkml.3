Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3H2Gab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:30:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3H2Gaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:30:30 -0400
Date: Wed, 28 Aug 2013 23:32:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: balbi@ti.com, stern@rowland.harvard.edu, USB <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: r8a66597-hcd: use platform_{get,set}_drvdata()
Message-ID: <20130829063251.GA30701@kroah.com>
References: <521C5EEE.1080505@huawei.com>
 <20130828043607.GA21756@kroah.com>
 <521EB7FB.6010004@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521EB7FB.6010004@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 10:54:51AM +0800, Libo Chen wrote:
> On 2013/8/28 12:36, Greg KH wrote:
> > On Tue, Aug 27, 2013 at 04:10:22PM +0800, Libo Chen wrote:
> >>
> >> Use the wrapper functions for getting and setting the driver data using
> >> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> >> so we can directly pass a struct platform_device.
> >>
> >> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> >> ---
> >>  drivers/usb/host/r8a66597-hcd.c |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > This patch doesn't apply to my tree :(
> 
> Hi Greg,
> 
> This patch based on mainline.
> Do you mean this patch got a conflicted in "git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git"
> 
> I need to rebase on "usb.git"?

Yes, please use the usb-next branch.

thanks,

greg k-h
