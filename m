Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161342AbaJ3VX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:23:58 -0400
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:49371 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934857AbaJ3VX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:23:57 -0400
Date: Thu, 30 Oct 2014 16:23:51 -0500
From: Jeff Epler <jepler@unpythonic.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: fix name of 'enable' sysfs file
Message-ID: <20141030212351.GA4590@unpythonic.net>
References: <20141030163028.GA22250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030163028.GA22250@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 09:30:28AM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Back in commit 5136b2da770d ("PCI: convert bus code to use dev_groups"),
> I misstyped the 'enable' sysfs file as 'enabled', which broke the
> userspace api.  This patch fixes that issue by renaming the file back.
> 
> Reported-by: Jeff Epler <jepler@unpythonic.net>
> Cc: stable <stable@vger.kernel.org> # 3.13
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Tested-by: Jeff Epler <jepler@unpythonic.net>

(with the caveat that, since LinuxCNC uses the -rt kernel, I tested this
change manually backported to 3.14-rt)

Thanks again for your fast action on this.

Jeff
