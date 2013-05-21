Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3EUNsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:48:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3EUNsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:48:01 -0400
Date: Tue, 21 May 2013 06:48:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] usb: add usb2 Link PM variables to sysfs and
 usb_device
Message-ID: <20130521134819.GA15963@kroah.com>
References: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com>
 <1369133017-3035-5-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369133017-3035-5-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 01:43:37PM +0300, Mathias Nyman wrote:
> Adds abitilty to tune L1 timeout (inactivity timer for usb2 link sleep)
> and BESL (best effort service latency)via sysfs.

If you add/remove/change sysfs files, you also need to do the same in
Documentation/ABI/ at the same time.  Please do so in this patch.

thanks,

greg k-h
