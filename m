Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3EUSkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:40:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3EUSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:40:48 -0400
Date: Tue, 21 May 2013 11:40:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Libo Chen <libo.chen@huawei.com>
Cc: davem@davemloft.net, samuel@sortiz.org, stern@rowland.harvard.edu,
        khc@pm.waw.pl, akpm@linux-foundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, alexander.shishkin@linux.intel.com,
        brudley@broadcom.com, thomas.petazzoni@free-electrons.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
Message-ID: <20130521184046.GA7827@kroah.com>
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369104120-35552-1-git-send-email-libo.chen@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:42:00AM +0800, Libo Chen wrote:
> I find a lot of mistakes using struct platform_driver without owner.
> So I pick up some of them including usb and net modules

Like others said, make the function call a macro that sets the module
owner in it, like all of the other major subsystem registration calls do
(usb_drivers, pci_drivers, etc.)

thanks,

greg k-h
