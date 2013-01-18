Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3ARVB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:01:27 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:33331 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3ARVBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:01:25 -0500
Date: Fri, 18 Jan 2013 13:01:21 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Cc: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>
Subject: Re: [PATCH 3/3] wlan-ng/prism2mgmt.c Replace printk(...) with
 netdev_warn, netdev_err
Message-ID: <20130118210121.GB12463@kroah.com>
References: <20130117205834.GA659@kroah.com>
 <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
 <1358464052-14002-4-git-send-email-qi50dube@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358464052-14002-4-git-send-email-qi50dube@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 12:07:32AM +0100, Sebastian Ehrenfels wrote:
> From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
> 
> We are uncertain if the netdev_struct is properly initialized in each function
> call. Please be sure to really review this patch.

If you are uncertian, then I'm sure not going to take this.  Please test
or do whatever you need to do to be certain :)

thanks,

greg k-h
