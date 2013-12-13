Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3LMXsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:48:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3LMXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:48:36 -0500
Date: Fri, 13 Dec 2013 15:50:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
Message-ID: <20131213235028.GA4919@kroah.com>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386973529-4884-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386973529-4884-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:23:35PM -0800, John Stultz wrote:
> From: Rebecca Schultz Zavin <rebecca@android.com>
> 
> Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
> [jstultz: Squished in Colin Cross' move to staging change]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/Kconfig                 |    2 +
>  drivers/staging/android/Makefile                |    2 +

This patch breaks the build if this option is enabled.

I suggest only adding the driver to the build _after_ it can be built,
for obvious reasons :)

Other than this "minor" thing, I have no objection to these patches at
all.  Can you redo this patch to fix this up, and maybe send another
patch adding it to the build and let me know at what point in the series
it should be applied?

Also, I only received 92 of these patches, not all 115, are they stuck
somewhere in a mail queue?

thanks,

greg k-h
