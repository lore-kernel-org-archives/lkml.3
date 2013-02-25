Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab3BYS4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:56:51 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:55185 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3BYS4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:56:46 -0500
Date: Mon, 25 Feb 2013 10:57:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, arve@android.com,
        john.stultz@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH] staging: android: ashmem: add 32bit compat support
Message-ID: <20130225185735.GA10342@kroah.com>
References: <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 06:44:35PM +0000, Serban Constantinescu wrote:
> Hi all,
> 
> As disussed with the Android kernel team I am resubmitting this patch
> without any modifications to the structure exchanged between kernel and
> userspace.

I'll need some acks or signed-off-by: on the patch from them, before I
can take this patch, thanks.

Oh, it's also too late for 3.9, 3.10 is the soonest this can go in, just
to set your expectations properly.

thanks,

greg k-h
