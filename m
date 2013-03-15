Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3COTGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:06:04 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51669 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3COTGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:06:02 -0400
Date: Fri, 15 Mar 2013 12:05:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] TTY: port hangup and close fixes
Message-ID: <20130315190558.GA16118@kroah.com>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362668153-10972-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 03:55:47PM +0100, Johan Hovold wrote:
> These patches against 3.9-rc1 fix a few issues with tty-port hangup and
> close.

Are these for 3.9-final?

thanks,

greg k-h
