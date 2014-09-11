Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaIKWAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:00:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaIKWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:00:11 -0400
Date: Thu, 11 Sep 2014 15:00:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Purnendu Kapadia <pro8linux@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: checkpatch fixes for sw_sync files
Message-ID: <20140911220010.GA8709@kroah.com>
References: <1410383449-28680-1-git-send-email-pro8linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410383449-28680-1-git-send-email-pro8linux@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:10:49PM +0100, Purnendu Kapadia wrote:
>    - add line after declaration
>    - allignment should match open parenthesis
>    - remove unnecessary new line
> 
> Signed-off-by: Purnendu Kapadia <pro8linux@gmail.com>
> ---
>  drivers/staging/android/sw_sync.c | 9 +++++----
>  drivers/staging/android/sw_sync.h | 2 +-
>  2 files changed, 6 insertions(+), 5 deletions(-)

This doesn't apply at all to my tree, what did you make it against?

Always work against linux-next, or my staging-next branch of staging.git
to ensure you don't duplicate work that has already been done.

thanks,

greg k-h
