Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaFJRS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:18:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJRS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:18:57 -0400
Date: Tue, 10 Jun 2014 10:22:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Raghavendra <raghav3276@gmail.com>
Cc: archanakumari959@gmail.com, paulmck@linux.vnet.ibm.com,
        ashvinivaratharaj@gmail.com, josh@joshtriplett.org,
        gulsah.1004@gmail.com, arrao@cdac.in, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: dot11d: Fixed coding style issues
Message-ID: <20140610172245.GA10995@kroah.com>
References: <1402419831-24436-1-git-send-email-arrao@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402419831-24436-1-git-send-email-arrao@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:33:51PM +0530, Raghavendra wrote:
> Replaced 'printk' with 'netdev_info' and 'netdev_err' wherever necessary.
> Also fixed the coding issue cooresponding to line gap after the declarations.

Please don't do multiple things in the same patch, a single patch should
only do 1 thing.  So break this up into multiple patches.

> Signed-off-by: Raghavendra <arrao@cdac.in>

I need "full" name for a signed-off-by: line, please read
Documentation/SubmittingPatches for the details.

thanks,

greg k-h
