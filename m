Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaGHXrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:47:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaGHXrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:47:16 -0400
Date: Tue, 8 Jul 2014 16:51:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Belur <askb23@gmail.com>
Cc: shalinmehta85@gmail.com, dan.carpenter@oracle.com, daeseok.youn@gmail.com,
        devel@driverdev.osuosl.org, speakup@braille.uwo.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: speakup: main.c - use time_after()
Message-ID: <20140708235141.GA31834@kroah.com>
References: <1404198022-19083-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404198022-19083-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 12:30:22PM +0530, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - this patch fixes jiffies comparision with a safer function to prevent
>   any overflows
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
>  drivers/staging/speakup/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This change is already in my tree, what branch are you working against?

greg k-h
