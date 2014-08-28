Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaH1PLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:11:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaH1PLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:11:02 -0400
Date: Thu, 28 Aug 2014 08:10:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen LinX <linx.z.chen@intel.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        "He, Bo" <bo.he@intel.com>
Subject: Re: [PATCH] debugfs: keep the old valid mode value when no explicity
 specify it
Message-ID: <20140828151020.GA17945@kroah.com>
References: <1409220549-15485-1-git-send-email-linx.z.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409220549-15485-1-git-send-email-linx.z.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 06:09:09PM +0800, Chen LinX wrote:
> From: "Chen, LinX" <linx.z.chen@intel.com>
> 
> When mount debugfs with no mode specifed after it's mounted, the mount
> point mode will change to default mode(0700) even the mount operation was fail,
> this will cause some issues like can't get binder info in android.

I don't understand, what did you do to get into this state?

And why does binder care about debugfs?

> Here we can keep the old valid mode if no explicity specify the mode
> value and also change the mode value even the mount fails if the mode
> value is specified.

I can't parse this sentence :(

> Change-Id: I591ce5328e9589adfc3d7317f04276bf0033202a

Please never put these markings in patches for inclusion in the upstream
kernel, as they make no sense.

thanks,

greg k-h
