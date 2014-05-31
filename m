Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaEaTwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:52:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaEaTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:52:07 -0400
Date: Sat, 31 May 2014 12:52:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tair Rzayev <tair.rzayev@gmail.com>
Cc: swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: binder.c: Use more appropriate
 functions for euid retrieval
Message-ID: <20140531195205.GA14077@kroah.com>
References: <538A30E6.6010403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538A30E6.6010403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 10:43:34PM +0300, Tair Rzayev wrote:
> Instead of getting the reference to whole credential structure, use
> task_euid() and current_euid() to get it.
> 
> Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
> ---
>  drivers/staging/android/binder.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

What kernel tree did you make this against?  It doesn't seem to match up
with what is in my staging-next branch to merge with Linus for the next
release, so please work against that one.

Oh, and I think this is already been done, although in a bit different
way there, please check to make sure it is correct.

thanks,

greg k-h
