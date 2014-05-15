Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaEOUbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:31:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEOUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:31:36 -0400
Date: Thu, 15 May 2014 13:34:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:dgnc:dgnc_driver open/close braces
Message-ID: <20140515203454.GA14523@kroah.com>
References: <1397061004-7924-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397061004-7924-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:30:04PM +0100, Paul McQuade wrote:
> ERROR: that open brace { should be on the previous line
> ERROR: else should follow close brace '}
> ERROR: space required before the open parenthesis '(
> ERROR: trailing whitespace
> ERROR: open brace '{' following function declarations go on the next line
> ERROR: space required after that ',' (ctx:VxV)
> ERROR: space required before the open parenthesis '('
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_driver.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)

There is something really odd in this patch that git refuses to apply
it.  Can you please refresh it and send it again, after verifying that
it will apply properly on your side?

The error I get is:

Applying: Staging:dgnc:dgnc_driver open/close braces
fatal: patch fragment without header at line 77: @@ -895,7 +893,7 @@ int dgnc_ms_sleep(ulong ms)

thanks,

greg k-h
