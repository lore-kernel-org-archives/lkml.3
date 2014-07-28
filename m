Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaG1Gra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:47:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaG1Gr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:47:28 -0400
Date: Sun, 27 Jul 2014 23:47:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 2/3] usb: gadget: f_fs: add ioctl returning ep
 descriptor
Message-ID: <20140728064700.GA1284@kroah.com>
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
 <1406295363-26998-3-git-send-email-r.baldyga@samsung.com>
 <xa1twqb1ttgq.fsf@mina86.com>
 <53D5F0E4.1090500@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D5F0E4.1090500@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:42:44AM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On 2014-07-25 16:15, Michal Nazarewicz wrote:
> >On Fri, Jul 25 2014, Robert Baldyga wrote:
> >>This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> >>returns endpoint descriptor to userspace. It works only if function
> >>is active.
> >I would argue that user space should never need to know the real
> >descriptor.  Is this ioctl needed for anything in particular?
> 
> Some proprietary broken usb protocols might embed real physical endpoint
> (or interface) number into the data stream. In such case functionfs driver
> is unable to do proper endpoint/interface number fixup.

Do you have an example of such a messed up thing?

greg k-h
