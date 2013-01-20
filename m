Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3ATXsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:48:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65414 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ATXr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:47:59 -0500
Date: Sun, 20 Jan 2013 15:47:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 19/21] ntb_netdev: declare unused variables and fix
 missing initializer
Message-ID: <20130120234756.GB21708@kroah.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
 <1358586155-23322-20-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358586155-23322-20-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 02:02:33AM -0700, Jon Mason wrote:
> Tag qp in ntb_netdev_tx_handler and net_device in ntb_get_settings as
> unused function parameters.  Also, correct missing initializer errors
> for 'struct device_driver' in ntb_netdev_client.  This corrects issues
> found by 'EXTRA_CFLAGS=-W'.

Again, why would you want to ever build the kernel with that option?
This shouldn't be needed.

greg k-h
