Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3JNSMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:12:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab3JNSMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:12:51 -0400
Date: Mon, 14 Oct 2013 11:12:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: usb: core: devio.c: Braces around switch
 (updated)
Message-ID: <20131014181250.GA6113@kroah.com>
References: <1381441292-6145-6-git-send-email-mail@beyermatthias.de>
 <1381575935-18868-1-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381575935-18868-1-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 01:05:35PM +0200, Matthias Beyer wrote:
> Added braces around switch statement as the styleguide tells us.
> Indented the switch-block for it and split a function call
> (driver->unlocked_ioctl() on line 1876) arguments to several lines to
> fit the 80-column convention.

This patch doesn't apply at all, any reason why?

confused,

greg k-h
