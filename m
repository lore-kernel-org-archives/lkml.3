Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaHJM0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:26:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaHJM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:26:01 -0400
Date: Sun, 10 Aug 2014 05:25:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vincent Bernat <vincent@bernat.im>
Cc: Eli Billauer <eli.billauer@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: fix some coding style errors
Message-ID: <20140810122526.GA29990@kroah.com>
References: <1405516782-11434-1-git-send-email-vincent@bernat.im>
 <20140810033413.GA20872@kroah.com>
 <m3y4uwsfp7.fsf@neo.luffy.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3y4uwsfp7.fsf@neo.luffy.cx>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 02:16:04PM +0200, Vincent Bernat wrote:
>  ❦  9 août 2014 20:34 -0700, Greg Kroah-Hartman <gregkh@linuxfoundation.org> :
> 
> >> This includes:
> >>  - keep "else" on the same line as the closing brace
> >>  - don't use "else" after "return"
> >
> >>  - don't issue a message for an out-of-memory error
> >>  - blank line after a declaration
> >> 
> >> Signed-off-by: Vincent Bernat <vincent@bernat.im>
> >> ---
> >>  drivers/staging/xillybus/xillybus_core.c | 13 +++++--------
> >>  1 file changed, 5 insertions(+), 8 deletions(-)
> >
> > This patch doesn't apply at all, as I think you made it against an old
> > kernel tree :(
> 
> Hi Greg!
> 
> You already applied this patch. It is almost one month old. Dunno why
> you received it a second time.

Ugh, you are right, somehow I never flushed it from my queue, sorry for
the noise.

greg k-h
