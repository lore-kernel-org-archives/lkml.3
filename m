Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaI1WB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 18:01:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaI1WB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 18:01:58 -0400
Date: Sun, 28 Sep 2014 18:01:01 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: jason@lakedaemon.net, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed Conditional white space problems
Message-ID: <20140928220101.GA25770@kroah.com>
References: <20140928215426.GA10384@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928215426.GA10384@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 04:54:26PM -0500, Eric Rost wrote:
> My first patch, resent to appropriate multiple addresses!

That's great, but it doesn't belong here in the body of the changelog :)

> This patch fixes the following checkpatch.pl Warnings:
> 
> WARNING: suspect code indent for conditional statements (16, 16)
> +               for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
> [...]
> +               {
> 
> WARNING: suspect code indent for conditional statements (16, 16)
> +               for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
> [...]
> +               {

Your subject should give a clue as to what part of the kernel it
modifies, for this patch, it might look like:
	staging: skein: fixed conditional...

Care to fix that up and resend?

thanks,

greg k-h
