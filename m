Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaGOPEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:04:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaGOPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:04:50 -0400
Date: Tue, 15 Jul 2014 08:04:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V4 1/6] staging: vt6556: Cleanup trivial coding style
 issues
Message-ID: <20140715150428.GA14053@kroah.com>
References: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:15:28PM +0200, Peter Senna Tschudin wrote:
> This patch cleans up the following checkpatch issues:
>  - tabs instead of spaces on the beginning of a line
>  - use correct /* */ comment style
>  - put { and } on the correct places
>  - line over 80 chars
>  - indentation style for multi-line calls / comments
>  - space after semicolon ,
>  - new line after declaration
> 
> Tested by compilation only.
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
> Cahnges from V3:
>  - Splitted the patches by change type

That's a lot of things to be doing all in one single patch, why didn't
you split this up further?

Please do so.

thanks,

greg k-h
