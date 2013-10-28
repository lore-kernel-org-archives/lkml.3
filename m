Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3J1QfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:35:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3J1QfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:35:11 -0400
Date: Mon, 28 Oct 2013 09:35:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, rucsoftsec@gmail.com, jslaby@suse.cz,
        airlied@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]tty:vt: Add NULL check to return value of kzalloc()
Message-ID: <20131028163510.GB4797@kroah.com>
References: <20131028162605.GA3738@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028162605.GA3738@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:26:05AM +0800, Wang YanQing wrote:
> In extreme situation kzalloc in con_init may
> return NULL, so we should check it to prevent
> OOPS!
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> Reported-by: rucsoftsec@gmail.com

I need a name for Reported-by: as well, not just an email.

> ---
>  I don't think a system without memory to initialize
>  vt could do some useful things, but this patch could
>  make debug easier and improve kernel code's robustness 
>  in theory.

Please always run your patches through the scripts/checkpatch.pl tool
and fix the problems found there so that maintainers don't have to point
out the same thing...

greg k-h
