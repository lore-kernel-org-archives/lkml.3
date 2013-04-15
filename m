Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3DOUOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:14:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59911 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3DOUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:14:23 -0400
Date: Mon, 15 Apr 2013 13:14:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v3 00/24] lockless n_tty receive path
Message-ID: <20130415201411.GA27360@kroah.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:19:04AM -0400, Peter Hurley wrote:
> Greg,
> 
> Unfortunately, this series is dependent on the 'ldsem patchset'.
> The reason is that this series abandons tty->receive_room as
> a flow control mechanism (because that requires locking),
> and the TIOCSETD ioctl _without ldsem_ uses tty->receive_room
> to shutoff i/o.

Can you also resend the ldsem patch series, as I no longer have it
around anymore, and I don't think it was part of this big resend, right?

thanks,

greg k-h
