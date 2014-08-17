Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaHQQvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:51:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaHQQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:51:13 -0400
Date: Sun, 17 Aug 2014 09:50:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ramesh Basukala <basukalaramesh@gmail.com>
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: fix coding style warning
Message-ID: <20140817165037.GA1390@kroah.com>
References: <20140815065506.GA26102@kroah.com>
 <1408117853-20400-1-git-send-email-basukalaramesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408117853-20400-1-git-send-email-basukalaramesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:50:53AM -0400, Ramesh Basukala wrote:
> This is a patch to the vendorspecificextn.c that fixes coding style
> warning message line over 80 characters found by checkpatch.pl script.
> I am submitting this patch as required by Eudyptula Challenge.
> 
> Signed-off-by: Ramesh Basukala <basukalaramesh@gmail.com>
> ---
>  drivers/staging/bcm/vendorspecificextn.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)

I think this patch is already applied, right?  If not, it doesn't apply,
so can you refresh and resend it?

thanks,

greg k-h
