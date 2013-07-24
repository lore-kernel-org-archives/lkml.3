Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3GXANC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:13:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3GXANA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:13:00 -0400
Date: Tue, 23 Jul 2013 17:12:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2 12/20] n_tty: Factor standard per-char i/o into
 separate fn
Message-ID: <20130724001259.GA9239@kroah.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-13-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371306096-5571-13-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:21:28AM -0400, Peter Hurley wrote:
> Simplify __receive_buf() into a dispatch function; perform per-char
> processing for all other modes not already handled.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_tty.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)

This patch causes the warning:
	drivers/tty/n_tty.c: In function ‘n_tty_receive_buf_standard’:
	drivers/tty/n_tty.c:1575:21: warning: unused variable ‘ldata’ [-Wunused-variable]
to happen.

Care to fix it up, and refresh the rest of the series (something fails
later on), and resend these so that I can apply them?

Everything before this was applied to my tree, you should have gotten
emails about them.

thanks,

greg k-h
