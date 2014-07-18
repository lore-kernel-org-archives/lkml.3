Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbaGRASZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:18:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaGRASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:18:23 -0400
Date: Thu, 17 Jul 2014 17:18:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Eli Billauer <eli.billauer@gmail.com>, devel@driverdev.osuosl.org,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] xillybus: place 'else' on same line as '}'
Message-ID: <20140718001823.GA24907@kroah.com>
References: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 08:07:00PM -0700, Jeremiah Mahler wrote:
> Place 'else' on same line as closing brace '}' as per
> Documentation/CodingStyle.  Fixes 1 error found by checkpatch.pl.
> 
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> ---
>  drivers/staging/xillybus/xillybus_core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Sorry, someone else sent this patch, which I applied already.  They did
so after you, but I missed this one as you didn't have the 'staging'
line on the Subject, my fault.

Sorry about that.

greg k-h
