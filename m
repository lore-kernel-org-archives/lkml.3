Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaEaGvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 02:51:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaEaGvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 02:51:46 -0400
Date: Sat, 31 May 2014 09:51:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        serban.constantinescu@arm.com, linux-kernel@vger.kernel.org,
        arve@android.com, john.stultz@linaro.org, prtvar.b@gmail.com
Subject: Re: [PATCH] Staging: android: binder: Fix over-80-char lines
Message-ID: <20140531065120.GK15585@mwanda>
References: <1401510680-13991-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401510680-13991-1-git-send-email-danieru.dressler@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What Neil said.

On Fri, May 30, 2014 at 10:31:20PM -0600, Daniel Dressler wrote:
> From: danieru <danieru.dressler@gmail.com>

This is wrong and we also get your name and email address from the
email headers so leave this line out.

> 
> Following Greg Kroah-Hartman's newbie guide to hacking
> the linux kernel this patch addresses only coding style
> issues.
> 
> Binder still has many too-long lines but I'm worried
> doing too much work in a single patch is unfair to the
> reviewers. So this patch address 20% of the file's
> issues.
> 
> There is one change to take notice of: it merges two if
> statement's conditionals together. Then it removes a
> redundant else clause.

Thanks for pointing this out, but the else statement wasn't redundant.
Your change introduces a bug.

Your patch doesn't apply.  You need to work against linux-next.

regards,
dan carpenter

