Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaCaPxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:53:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaCaPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:53:07 -0400
Date: Mon, 31 Mar 2014 08:55:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Vegas <thomas_75@safe-mail.net>
Cc: joe@perches.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: serqt_usb2: Fix coding style issues.
Message-ID: <20140331155512.GA7217@kroah.com>
References: <f10faefdec9dffd231e8e020c2b6af38@mwinf5d69.me-wanadoo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10faefdec9dffd231e8e020c2b6af38@mwinf5d69.me-wanadoo.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 08:51:04AM +0200, Thomas Vegas wrote:
> Add blank lines after declarations and cleanup initializations.

Patches should do only 1 thing, not multiple things if at all possible.

So this should be 2 patches, not one.  Care to break it up like that and
resend 2 patches instead?

thanks,

greg k-h
