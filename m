Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3CEK12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:27:28 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33546 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3CEK10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:27:26 -0500
Date: Tue, 5 Mar 2013 18:27:45 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, arve@android.com,
        john.stultz@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH] staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
Message-ID: <20130305102745.GA3327@kroah.com>
References: <20130305083707.GA7513@kroah.com>
 <1362478708-26946-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362478708-26946-1-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 10:18:27AM +0000, Serban Constantinescu wrote:
> Android's shared memory subsystem, Ashmem, does not support calls from a
> 32bit userspace in a 64 bit kernel. This patch adds support for syscalls
> coming from a 32bit userspace in a 64bit kernel.
> 
> The patch has been successfully tested on ARMv8 AEM(64bit
> platform model) and Versatile Express A9(32bit platform).
> 
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/ashmem.c |   22 +++++++++++++++++++++-
>  drivers/staging/android/ashmem.h |    6 ++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)

Ok, what has changed from your previous version that I rejected that is
going to actually allow this to build?

Hint, you gotta tell me what version of the patch this is, and what
changed, otherwise I'll just assume this is a resend of the previous
patch and go ahead and delete it from my queue.

In fact, I might as well do that, now deleted :)

greg k-h
