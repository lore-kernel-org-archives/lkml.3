Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3CaPCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 11:02:40 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41139 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3CaPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 11:02:38 -0400
Date: Sun, 31 Mar 2013 08:02:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: frankie lin <frankiefrankie.lin@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, open <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] TTY Fix NULL pointer error in tty_wakeup
Message-ID: <20130331150210.GC9494@kroah.com>
References: <1364630323-3078-1-git-send-email-frankiefrankie.lin@gmail.com>
 <20130330151801.GA16237@kroah.com>
 <CAD-pLEFtw0=j+jL2+ecqKShdz_GOSmfAzn3T0+3mr=5Ofnks7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-pLEFtw0=j+jL2+ecqKShdz_GOSmfAzn3T0+3mr=5Ofnks7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Sun, Mar 31, 2013 at 04:09:05PM +0800, frankie lin wrote:
> Hi, greg, it's excited to get your reply.
> In our case, it is gs_start_io(struct gs_port *port) in the file u_serial.c who
> call the tty_wakeup. We are trying to find the root cause.  Something is wrong
> before calling tty_wakeup, nevertheless it is reasonable to check the parameter
> first before test_bit.

No, please find the root problem here in your driver.

> To some extent, this patch can improve the robustness of function tty_wakeup,
> isn't it?

Not at the expense of papering over other bugs, sorry.

greg k-h
