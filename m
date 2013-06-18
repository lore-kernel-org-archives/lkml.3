Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab3FRScP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:32:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3FRScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:32:13 -0400
Date: Tue, 18 Jun 2013 11:32:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/4 v3] silicom: checkpatch: assignments in if conditions
Message-ID: <20130618183212.GA8182@kroah.com>
References: <1371496539-25461-1-git-send-email-lorenz@badgers.com>
 <1371572918-25493-1-git-send-email-lorenz@badgers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371572918-25493-1-git-send-email-lorenz@badgers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:28:38PM +0200, Lorenz Haspel wrote:
> Fixes checkpatch error:
> There were assignments in if conditions, so I extracted them.
> 
> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
> ---
> v2: removed some buggy extra lines and fixed white space issues
> v3: fixed some more extra lines
> ---
>  drivers/staging/silicom/bpctl_mod.c |  179 +++++++++++++++++++----------------
>  1 file changed, 98 insertions(+), 81 deletions(-)

I'm getting confused.  I've applied some of the patches in this series,
so are you going to resend all 4 patches?

How about just resending what I haven't applied yet, as a whole new
series, that would help out on my end a lot.

thanks,

greg k-h
