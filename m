Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaIYMjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:39:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIYMi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:38:59 -0400
Date: Thu, 25 Sep 2014 14:38:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, Paul.Zimmerman@synopsys.com,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/6] usb: dwc2/gadget: move phy bus legth initialization
Message-ID: <20140925123803.GA2095@kroah.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
 <1410252297-13738-2-git-send-email-r.baldyga@samsung.com>
 <54240A12.3080206@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54240A12.3080206@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 02:26:58PM +0200, Marek Szyprowski wrote:
> Hi Greg and Paul,
> 
> On 2014-09-09 10:44, Robert Baldyga wrote:
> >From: Kamil Debski <k.debski@samsung.com>
> >
> >This patch moves the part of code that initializes the PHY bus width.
> >This results in simpler code and removes the need to check whether
> >the Generic PHY Framework is used.
> 
> I've noticed that patches from this patchset have been finally merged to
> usb-next tree, but I cannot find this patch there. Is there any reason for
> dropping it?

Ugh, did I miss it somehow?

Yes I did, sorry about that, now applied...

thanks for picking this out.

greg k-h
