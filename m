Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3KGPYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:24:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40391 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750996Ab3KGPYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:24:48 -0500
Date: Thu, 7 Nov 2013 10:24:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: George Cherian <george.cherian@ti.com>
cc: balbi@ti.com, <bigeasy@linutronix.de>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: gadget: f_mass_storage: call try_to_freeze only
 when its safe
In-Reply-To: <1383833210-26656-1-git-send-email-george.cherian@ti.com>
Message-ID: <Pine.LNX.4.44L0.1311071021560.1401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, George Cherian wrote:

> Call try_to_freeze() in sleep_thread() only when its safe to sleep.
> do_read() and do_write() calls sleep_thread with lock held.
> Make sure these wont call try_to_freeze() by passing can_freeze flag
> to sleep_thread.
> 
> Calling try_to_freeze() with a lock hold was done since day one in
> f_mass_storage but since commit 0f9548ca1 ("lockdep: check that no
> locks held at freeze time") lockdep complains about it.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Although I would have preferred it if you spelled "it's" and "won't"  
with apostrophes in the first paragraph.  Without the apostrophes,
"its" is a possessive pronoun (meaning "something belonging to it")
and "wont" is a noun (meaning "habit").

Alan Stern

