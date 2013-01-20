Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3ATXme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:42:34 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:59595 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3ATXmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:42:32 -0500
Date: Sun, 20 Jan 2013 15:42:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 08/21] NTB: declare unused variables
Message-ID: <20130120234228.GC14196@kroah.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
 <1358586155-23322-9-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358586155-23322-9-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 02:02:22AM -0700, Jon Mason wrote:
> Tag pci_device_id in ntb_pci_probe as unused function parameters.  This
> corrects issues found by 'EXTRA_CFLAGS=-W'.

Why would you build the kernel with that option?  This isn't needed, so
I'm not going to apply it.

thanks,

greg k-h
