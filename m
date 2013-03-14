Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3CNU6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:58:10 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64206 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3CNU6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:58:09 -0400
Date: Thu, 14 Mar 2013 13:52:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable request] TTY: do not reset master's packet mode
Message-ID: <20130314205230.GA11847@kroah.com>
References: <5141AE1F.40308@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5141AE1F.40308@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:01:51PM +0100, Jiri Slaby wrote:
> Hi,
> 
> please include the patch below to all maintained stable trees.
> 
> commit b81273a132177edd806476b953f6afeb17b786d5
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Tue Jan 15 23:26:22 2013 +0100
> 
>     TTY: do not reset master's packet mode

Applied to 3.8-stable, 3.4-stable, and 3.0-stable, thanks.

greg k-h
