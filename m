Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaKZV6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:58:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZV6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:58:03 -0500
Date: Wed, 26 Nov 2014 13:58:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking
 module params state
Message-ID: <20141126215801.GA32756@kroah.com>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
 <1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:38:46PM +0100, Mariusz Gorski wrote:
> Avoid magic number and use a comparison with a defined value instead
> that checks whether module param has been set by the user to some
> value at loading time.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> Acked-by: Willy Tarreau <w@1wt.eu>
> ---
> v2: Don't introduce new macros for param value check
> 
>  drivers/staging/panel/panel.c | 86 +++++++++++++++++++++----------------------
>  1 file changed, 43 insertions(+), 43 deletions(-)

Ugh, I messed up here, and applied the first series, which was acked.

Mariusz, can you resend the patches that I didn't apply, I can't seem to
get the rest of these to work properly.

thanks,

greg k-h
