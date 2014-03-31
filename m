Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaCaWxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:53:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaCaWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:53:30 -0400
Date: Mon, 31 Mar 2014 15:55:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anders Darander <anders.darander@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: ft1000-usb: fixed a few code style issues
Message-ID: <20140331225549.GA27227@kroah.com>
References: <1396247188-6513-1-git-send-email-anders.darander@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396247188-6513-1-git-send-email-anders.darander@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 08:26:28AM +0200, Anders Darander wrote:
> Fixed a few code style issues, particularly:
> 
> Add do {} while (0) wrapper around seq_* macros.
> Change printk(KERN_WARN...) to netdev_warn(...).

That's 2 different things, please split this up into 2 different
patches.

Remember, one patch does one thing.

thanks,

greg k-h
